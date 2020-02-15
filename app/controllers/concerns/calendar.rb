module Calendar
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
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

end
