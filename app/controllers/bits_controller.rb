class BitsController < ApplicationController
  before_action :set_bit, only: [:show, :edit, :update, :destroy, :flowchart]
  before_action :set_ownership, only: [:edit, :update]

  def flowchart
    @events = [find_root_predecessor(@bit)]
  end

  def table
    # using ownerships for eager-loading does not avoid the less-likely probiem that bits are not uniq.
    @ownerships = current_user.ownerships.includes(:bit).order('bits.updated_at DESC')
    session[:after_destroy_location] = table_path
  end

  # only for autocomplete parent. @bit could be nil (new bit)
  def tags
    @tags = current_user.tags

    if (@q = params[:q]) && @q.present?
      @tags = @tags.select do |tag|
        tag.downcase.include?(@q.downcase)
      end
    end

    render layout: false
  end

  def parents
    if (@q = params[:q]) && @q.present?
      @parents = [current_user.bits.find_all_by_generation(0).where("title ILIKE ?", "%#{@q}%"), current_user.bits.find_all_by_generation(1).where("title ILIKE ?", "%#{@q}%")]
    else
      @parents = [current_user.bits.find_all_by_generation(0), current_user.bits.find_all_by_generation(1)]
    end

    @parents = @parents.flatten.compact

    if params[:id].present? && (@bit = current_user.bits.find(params[:id]))
      @parents.delete_if { |bit| bit == @bit }
    end

    render layout: false
  end

  # GET /favorites
  def favorites
    @bits = current_user.bits.favorites.recent_first
    @pagy, @bits = pagy(@bits, items: 12)
    session[:after_destroy_location] = favorites_path
  end

  def events
    @bits = current_user.bits.events
    case params[:query].try(:downcase)
    when 'past'
      @bits = @bits.where('end_at < ?', DateTime.current.beginning_of_day).order('end_at DESC')
    when 'current'
      @bits = @bits.occur_in(DateTime.current.beginning_of_day..DateTime.current.end_of_day).order('begin_at ASC')
      if (@bits.count == 0)
        redirect_to(events_path(query: :future), notice: 'No current events') and return
      end
    when 'future'
      @bits = @bits.where('begin_at > ?', DateTime.current.end_of_day).order('begin_at ASC')
    else
      redirect_to(events_path(query: :current)) and return
    end
    @pagy, @bits = pagy(@bits, items: 12)
    session[:after_destroy_location] = events_path
  end

  def tasks
    @bits = current_user.bits.tasks
    case params[:query].try(:downcase)
    when 'ongoing'
      @bits = @bits.where(status: [:todo, :ongoing])
    when 'completed'
      @bits = @bits.where(status: :completed)
    when 'waiting'
      @bits = @bits.where(status: :waiting)
    when 'all'
      @bits = @bits
    else
      redirect_to(tasks_path(query: :ongoing)) and return
    end
    @bit = @bits.order('due_at ASC')
    @pagy, @bits = pagy(@bits, items: 12)
    session[:after_destroy_location] = tasks_path
  end

  def links
    # using ownerships for eager-loading does not avoid the less-likely probiem that bits are not uniq.
    @ownerships = current_user.ownerships.includes(:bit).where.not(bits: {uri: ''}).order('bits.updated_at DESC')
    @pagy, @ownerships = pagy(@ownerships, items: 12)
    session[:after_destroy_location] = links_path
  end

  # GET /bits
  # GET /bits.json
  def index
    # using ownerships for eager-loading does not avoid the less-likely probiem that bits are not uniq.
    @ownerships = current_user.ownerships.includes(:bit).order('bits.updated_at DESC')
    @pagy, @ownerships = pagy(@ownerships, items: 12)
    session[:after_destroy_location] = bits_path
  end

  # GET /bits/1
  # GET /bits/1.json
  def show
    @markdown = @bit.content.present? ? @@markdown.render(@bit.content) : ''
    @children = @bit.children.reorder('updated_at DESC')
  end

  # GET /bits/new
  def new
    @bit = Bit.new
    @ownership = Ownership.new
  end

  # GET /bits/1/edit
  def edit
  end

  # POST /bits
  # POST /bits.json
  def create
    attrs = params_with_time_zone_adjusted

    @bit = Bit.new(attrs)

    if @bit.title.blank? && @bit.uri.present?
      @bit.get_meta
    end

    respond_to do |format|
      if @bit.valid? && current_user.ownerships.create(bit: @bit)
        @ownership = current_user.ownerships.find_by(bit: @bit)
        @ownership.update(ownership_params)
        format.html { redirect_to @bit, notice: 'Bit was successfully created.' }
        format.json { render :show, status: :created, location: @bit }
      else
        @ownership = Ownership.new
        format.html { render :new }
        format.json { render json: @bit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bits/1
  # PATCH/PUT /bits/1.json
  def update
    attrs = params_with_time_zone_adjusted

    respond_to do |format|
      if @bit.update(attrs)
        @ownership.update(ownership_params)
        format.html { redirect_to @bit, notice: 'Bit was successfully updated.' }
        format.json { render :show, status: :ok, location: @bit }
      else
        format.html { render :edit }
        format.json { render json: @bit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bits/1
  # DELETE /bits/1.json
  def destroy
    @bit.destroy
    respond_to do |format|
      format.html { redirect_to (session[:after_destroy_location] || bits_url), notice: 'Bit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def find_root_predecessor(bit)
      if bit.predecessor.present?
        find_root_predecessor(bit.predecessor)
      else
        bit
      end
    end

    def params_with_time_zone_adjusted
      attrs = bit_params
      attrs[:due_at] = add_zone_to_datetime(attrs.delete(:due_at), attrs[:due_at_time_zone])
      attrs[:begin_at] = add_zone_to_datetime(attrs.delete(:begin_at), attrs[:begin_at_time_zone])
      attrs[:end_at] = add_zone_to_datetime(attrs.delete(:end_at), attrs[:end_at_time_zone])
      if attrs[:begin_at].present? && attrs[:end_at].blank?
        attrs[:end_at] = (attrs[:due_at] || (attrs[:begin_at]+1.day))
      end
      attrs
    end

    # adjust time zone. Input date in string to parse, zone in string, and return in TimeWithZone.
    def add_zone_to_datetime date, zone
      if date.present? && zone.present?
        Time.use_zone(zone) { Time.zone.parse(date) }
      else
        date
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_bit
      @bit = current_user.bits.find(params[:id])
    end

    def set_ownership
      @ownership = current_user.ownerships.find_by(bit: @bit)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bit_params
      params.require(:bit).permit(:user_id, :title, :description, :content, :uri, :parent_id, :status, :due_at, :due_at_time_zone, :begin_at, :end_at, :begin_at_time_zone, :end_at_time_zone, :all_day, :predecessor_id)
    end

    def ownership_params
      params[:ownership].present? ? params.require(:ownership).permit(:tag_list, :favorite) : {}
    end
end
