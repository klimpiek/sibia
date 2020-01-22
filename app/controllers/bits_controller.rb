class BitsController < ApplicationController
  before_action :set_bit, only: [:show, :edit, :update, :destroy]
  before_action :set_ownership, only: [:edit, :update]

  # GET /favorites
  def favorites
    @bits = current_user.bits.favorites.recent_first
    @pagy, @bits = pagy(@bits, items: 12)
  end

  def events
    @bits = current_user.bits.events.order('due_at ASC')
    @pagy, @bits = pagy(@bits, items: 12)
  end

  def tasks
    @bits = current_user.bits.tasks.order('due_at ASC')
    case params[:query].try(:downcase)
    when 'ongoing'
      @bits = @bits.where(status: [:todo, :ongoing])
    when 'completed'
      @bits = @bits.where(status: :completed)
    when 'waiting'
      @bits = @bits.where(status: :waiting)
    end
    @pagy, @bits = pagy(@bits, items: 12)
  end

  def links
    @bits = current_user.bits.links.recent_first
    @pagy, @bits = pagy(@bits, items: 12)
  end

  # GET /bits
  # GET /bits.json
  def index
    @bits = current_user.bits.recent_first
    @pagy, @bits = pagy(@bits, items: 12)
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
      if current_user.ownerships.create(bit: @bit) && @bit.valid?
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
      format.html { redirect_to bits_url, notice: 'Bit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def params_with_time_zone_adjusted
      attrs = bit_params
      attrs[:due_at] = add_zone_to_datetime(attrs.delete(:due_at), attrs[:due_at_time_zone])
      attrs[:begin_at] = add_zone_to_datetime(attrs.delete(:begin_at), attrs[:begin_at_time_zone])
      attrs[:end_at] = add_zone_to_datetime(attrs.delete(:end_at), attrs[:end_at_time_zone])
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
      params.require(:bit).permit(:user_id, :title, :description, :content, :uri, :parent_id, :status, :due_at, :due_at_time_zone, :begin_at, :end_at, :begin_at_time_zone, :end_at_time_zone, :all_day)
    end

    def ownership_params
      params[:ownership].present? ? params.require(:ownership).permit(:tag_list, :favorite) : {}
    end
end