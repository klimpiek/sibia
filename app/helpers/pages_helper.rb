module PagesHelper
  # return offsetX in calendar week. X is 1-7.
  def calendar_event_span(bit, week)
    if (bit.end_at > week.end_of_week)
      if (bit.begin_at < week.beginning_of_week)
        "span7"
      else
        "span#{7-(bit.begin_at.beginning_of_day.to_i-week.beginning_of_week.to_i)/(24*60*60)}"
      end
    else
      if (bit.begin_at < week.beginning_of_week)
        "span#{bit.end_at.wday}"
      else
        "span#{(bit.end_at.beginning_of_day.to_i-bit.begin_at.beginning_of_day.to_i)/(24*60*60)+1}"
      end
    end
  end

  # return {id:, title: start: 0-720, end: 0-720, url} as agenda event
  def agenda_event(bit, weekday, user_time_zone)
    agenda_begin = DateTime.new(weekday.year, weekday.month, weekday.day, 9, 0, 0, user_time_zone).to_i
    agenda_end = DateTime.new(weekday.year, weekday.month, weekday.day, 21, 0, 0, user_time_zone).to_i

    data = nil

    start_i = (bit.begin_at.to_i-agenda_begin)/60
    end_i = (bit.end_at.to_i-agenda_begin)/60

    if ((start_i >= 0) && (end_i >= 0) && (start_i <= 720) && (end_i <= 720))
      data={ \
             id: bit.id, \
             title: bit.title, \
             start: start_i, \
             end: end_i, \
             url: bit_path(bit) \
           }
    elsif ((start_i < 0) && (end_i >= 0) && (end_i <= 720))
      data={ \
             id: bit.id, \
             title: bit.title, \
             start: 0, \
             end: end_i, \
             url: bit_path(bit) \
           }
    elsif ((start_i < 0) && (end_i > 720))
      data={ \
             id: bit.id, \
             title: bit.title, \
             start: 0, \
             end: (agenda_end-agenda_begin) / 60, \
             url: bit_path(bit) \
           }
    elsif ((start_i >= 0) && (start_i <= 720) && (end_i > 720))
      data={ \
             id: bit.id, \
             title: bit.title, \
             start: start_i, \
             end: (agenda_end-agenda_begin) / 60, \
             url: bit_path(bit) \
           }
    end

    data
  end

  def gantt_columns(begin_at, end_at, start_date, period)
    columns = "1/1"
    case period
    when 'year'
      b = ((begin_at.end_of_day+4.weeks).to_i-start_date.end_of_day.to_i)/(7*24*60*60)
      e = ((end_at.end_of_day+4.weeks).to_i-start_date.end_of_day.to_i)/(7*24*60*60)
      b = 0 if b < 0
      columns = "#{b+1}/#{e+2}"
    when 'month'
      b = ((begin_at.end_of_day+7.days).to_i-start_date.end_of_day.to_i)/(24*60*60)
      e = ((end_at.end_of_day+7.days).to_i-start_date.end_of_day.to_i)/(24*60*60)
      b = 0 if b < 0
      columns = "#{b+1}/#{e+2}"
    end
    p columns
    columns
  end
end
