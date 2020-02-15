module Gantt
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

end
