module DateTimeHelper
  # output: 08 Jan 12:00 (Taipei)
  def due_at_with_time_zone(bit)
    time_zone = bit.due_at_time_zone || current_user.time_zone
    "#{bit.due_at.in_time_zone(time_zone).to_formatted_s(:short)} (#{time_zone})"
  end

  # output: 10-12 February 2020
  def event_with_time(bit)
    time_zone = bit.begin_at_time_zone || current_user.time_zone
    Time.use_zone(time_zone) do
      DateRangeFormatter.format(bit.begin_at, bit.end_at, (bit.all_day ? :default : :with_time))
    end
  end
end
