module DateTimeHelper
  # output: 'due in 8 days' or 'overdue 7 days ago'
  def due_in_time_ago(bit)
    if bit.due_at.present?
      s = time_ago_in_words(bit.due_at)
      if bit.due_at < DateTime.current
        "overdue #{s} ago"
      else
        "due in #{s}"
      end
    else
      ''
    end
  end

  # output: 08 Jan 12:00 (Taipei)
  def due_at_with_time_zone(bit)
    time_zone = bit.due_at_time_zone || current_user.time_zone
    "#{bit.due_at.in_time_zone(time_zone).to_formatted_s(:short)} (#{time_zone})"
  end

  # output: '08 Jan 12:00' with time_zone if different from user's
  def due_at_with_optional_time_zone(bit)
    time_zone = bit.due_at_time_zone || current_user.time_zone
    s = "#{bit.due_at.in_time_zone(time_zone).to_formatted_s(:short)}"
    if (bit.due_at_time_zone != current_user.time_zone)
      s = s + " (#{time_zone})"
    end
    s
  end

  # output: 10-12 February 2020
  def event_with_time(bit)
    time_zone = bit.begin_at_time_zone || current_user.time_zone
    Time.use_zone(time_zone) do
      DateRangeFormatter.format(bit.begin_at, bit.end_at, (bit.all_day ? :default : :with_time))
    end
  end
end
