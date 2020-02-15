module Events
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
  end

  def set_gantt(query, start_date)
    case query
    when 'week'
      @period = 'week'
      @date_range = (start_date.beginning_of_week..start_date.end_of_week)
      @unit = (1..7).to_a
      @marker = DateTime.current.cwday
    when 'year'
      @period = 'year'
      @unit = 'week'
      @date_range = (start_date.beginning_of_day-4.weeks..start_date.end_of_day+48.weeks)
      @units = (-4..48).collect do |diff|
        date = start_date.end_of_day+diff.send(:weeks)
        unit = date.cweek
        {date: date, unit: unit}
      end
      @marker = DateTime.current.end_of_day
    else
      @period = 'month'
      @unit = 'day'
      @date_range = (start_date.beginning_of_day-7.days..start_date.end_of_day+45.days)
      @units = @date_range.collect do |date| {date: date.end_of_day, unit: date.day} end
      @marker = DateTime.current.end_of_day
    end
  end

  def set_calendar(query, start_date)
    case query
    when 'week'
      @user_selection = 'week'
      @period = 'week'
      @period_count = 1
      @prev_date = start_date-1.week
      @next_date = start_date+1.week
      @date_range = (start_date.beginning_of_week..start_date.end_of_week)
    when 'quarter'
      @user_selection = 'quarter'
      @period = 'month'
      @period_count = 3
      @prev_date = start_date-1.month
      @next_date = start_date+1.month
      @date_range = (start_date.beginning_of_month.beginning_of_week..(start_date+3.months).end_of_week)
    when 'year'
      @user_selection = 'year'
      @period = 'year'
      @period_count = 1
      @prev_date = start_date-1.year
      @next_date = start_date+1.year
      @date_range = (start_date.beginning_of_year.beginning_of_week..start_date.end_of_year.end_of_week)
    else
      @user_selection = 'month'
      @period = 'month'
      @period_count = 1
      @prev_date = start_date-1.month
      @next_date = start_date+1.month
      @date_range = (start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
    end
  end

  def set_agenda(start_date)
    @prev_date = @start_date-1.week
    @next_date = @start_date+1.week
    @date_range = (@start_date.beginning_of_week..@start_date.end_of_week)
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
