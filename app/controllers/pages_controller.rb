class PagesController < ApplicationController
  include Gantt
  include Calendar
  include Agenda

  skip_before_action :authenticate_user!, only: [:home, :help]

  def tags
    @tags = current_user.tags

    @ownerships = current_user.ownerships.where.not(tags: [])
  end

  def search
    if params[:q].present? && @search_params = params.require(:q)
      if @search_params.kind_of?(String)
        @search_params = SearchService::Base.parse_keyword_search(@search_params)
      end
      @bits = SearchService::Bit.new(current_user.bits).search(query: @search_params).order('updated_at DESC')
    else
      redirect_to root_path
    end
  end

  def advanced
  end

  def workspace
    @tasks = current_user.bits.tasks.where.not(status: :completed)
    Time.use_zone(current_user.time_zone) do
      @events = current_user.bits.events.occur_in(DateTime.current.beginning_of_day..DateTime.current.end_of_week).order('begin_at ASC').limit(20)
    end
    @roots = current_user.bits.roots.includes(:children, children: [:children]).recent_first
    @pagy, @roots = pagy(@roots, items: 12)
  end

  def dashboard
    @avatar_initial = current_user.email[0].upcase
  end

  def help
  end

  def home
  end

  def vue
  end

  def gantt
    @start_date = start_date
    set_gantt(params[:period].try(:downcase), @start_date)

    @events = current_user.bits.events.occur_in(@date_range).includes(:predecessor).order("begin_at ASC")
  end

  def calendar
    @start_date = start_date
    set_calendar(params[:selection].try(:downcase), @start_date)

    @events = current_user.bits.events.occur_in(@date_range)
  end

  def agenda
    @start_date = start_date
    set_agenda(@start_date)

    @events = current_user.bits.events.occur_in(@date_range)
    @all_day_events = @events.where(all_day: true)
    @events_with_time = @events.where(all_day: false)
  end

  private

    def start_date
      Time.use_zone(current_user.time_zone) do
        if params[:start_date].present?
          date = Time.zone.parse(params[:start_date]).to_datetime
        else
          date = DateTime.current
        end
      end
    end

end
