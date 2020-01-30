module BitsHelper
  def parent_autocomplete_url(bit)
    if bit.persisted?
      parents_bit_path(bit)
    else
      parents_bits_path
    end
  end

  def status_icon(bit, options = {})
    color = 'text-primary'
    icon = case bit.status
    when "todo"
      "radio_button_unchecked"
    when "ongoing"
      "play_circle_outline"
    when "waiting"
      color = 'text-warning'
      "pause_circle_outline"
    when "completed"
      color = 'text-success'
      "check_circle"
    end

    options.reverse_merge!(class: "", title: bit.status)
    options[:class] = options[:class] + " material-icons-outlined #{color}"

    tag.i icon, options
  end

  def status_label(bit)
    label_klass = 'label-secondary'

    case bit.status
    when 'unassigned'
    when 'todo'
      label_klass = 'label-primary'
    when 'ongoing'
      label_klass = 'label-success'
    when 'waiting'
      label_klass = 'label-warning'
    when 'completed'
      label_klass = ''
    end
  
    tag.span bit.status, {class: ["label", label_klass]}
  end
end
