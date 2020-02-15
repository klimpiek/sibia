module Agenda
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
  end

  def set_agenda(start_date)
    @prev_date = @start_date-1.week
    @next_date = @start_date+1.week
    @date_range = (@start_date.beginning_of_week..@start_date.end_of_week)
  end

end
