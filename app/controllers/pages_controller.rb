class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :help]

  def gantt
    @start_date = start_date

    case params[:period].try(:downcase)
    when 'week'
      @period = 'week'
      @prev_date = @start_date-1.week
      @next_date = @start_date+1.week
      @date_range = (@start_date.beginning_of_week..@start_date.end_of_week)
      @unit = (1..7).to_a
      @marker = DateTime.current.cwday
    when 'year'
      @period = 'year'
      @unit = 'week'
      @prev_date = @start_date-1.year
      @next_date = @start_date+1.year
      @date_range = (@start_date.beginning_of_day-4.weeks..@start_date.end_of_day+48.weeks)
      @units = (-4..48).collect do |diff| 
        date = @start_date.end_of_day+diff.send(:weeks)
        unit = date.cweek
        {date: date, unit: unit}
      end
      @marker = DateTime.current.end_of_day
    else
      @period = 'month'
      @unit = 'day'
      @prev_date = @start_date-1.month
      @next_date = @start_date+1.month
      @date_range = (@start_date.beginning_of_day-7.days..@start_date.end_of_day+45.days)
      @units = @date_range.collect do |date| {date: date.end_of_day, unit: date.day} end
      @marker = DateTime.current.end_of_day
    end

    @events = current_user.bits.events.occur_in(@date_range)
    @tasks = current_user.bits.tasks.due_in(@date_range)

  end

  def calendar
    @start_date = start_date

    case params[:selection].try(:downcase)
    when 'week'
      @user_selection = 'week'
      @period = 'week'
      @period_count = 1
      @prev_date = @start_date-1.week
      @next_date = @start_date+1.week
      @date_range = (@start_date.beginning_of_week..@start_date.end_of_week)
    when 'quarter'
      @user_selection = 'quarter'
      @period = 'month'
      @period_count = 3
      @prev_date = @start_date-1.month
      @next_date = @start_date+1.month
      @date_range = (@start_date.beginning_of_month.beginning_of_week..(@start_date+3.months).end_of_week)
    when 'year'
      @user_selection = 'year'
      @period = 'year'
      @period_count = 1
      @prev_date = @start_date-1.year
      @next_date = @start_date+1.year
      @date_range = (@start_date.beginning_of_year.beginning_of_week..@start_date.end_of_year.end_of_week)
    else
      @user_selection = 'month'
      @period = 'month'
      @period_count = 1
      @prev_date = @start_date-1.month
      @next_date = @start_date+1.month
      @date_range = (@start_date.beginning_of_month.beginning_of_week..@start_date.end_of_month.end_of_week)
    end

    @events = current_user.bits.events.occur_in(@date_range)
    @tasks = current_user.bits.tasks.due_in(@date_range)
  end

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
    @roots = current_user.bits.roots.recent_first
    @pagy, @roots = pagy(@roots, items: 12)
  end

  def dashboard
    @avatar_initial = current_user.email[0].upcase
    @lines = current_user.lines
  end

  def help
  end

  def home
  end

  def vue
  end

  def agenda
    @start_date = start_date
    @prev_date = @start_date-1.week
    @next_date = @start_date+1.week
    @date_range = (@start_date.beginning_of_week..@start_date.end_of_week)

    @events = current_user.bits.events.occur_in(@date_range)
    @all_day_events = @events.where(all_day: true)
    @events_with_time = @events.where(all_day: false)

    @tasks = current_user.bits.tasks.due_in(@date_range)
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
