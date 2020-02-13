module BitsHelper

  # output uri as link with icon-bookmark
  def link_with_bookmark_icon(bit)
    if bit.uri.present?
      link_to bit.uri, {target: '_blank', rel:"noopener noreferrer", class: 'btn btn-primary'} do
        tag.i class: %w( icon icon-bookmark )
      end
    else
      link_to '#', {class: 'btn d-invisible'} do
        tag.i class: %w( icon )
      end
    end
  end

  def task_status_with_icon(bit)
    if bit.unassigned?
      # tag.button class: %w{btn btn
    else
    end
  end

  def status_icon(bit, options = {})
    color = 'text-secondary'
    icon = ''
    extra_btn_class = ''

    case bit.status
    when 'unassigned'
      color = 'd-invisible'
      icon = ''
      extra_btn_class = 'd-invisible'
    when 'todo'
      icon = "radio_button_unchecked"
    when 'ongoing'
      icon = "play_circle_outline"
    when 'waiting'
      color = 'text-warning'
      icon = "pause_circle_outline"
    when 'completed'
      color = 'text-success'
      icon = "check_circle"
    end

    options.reverse_merge!(class: "", title: bit.status)
    options[:class] = options[:class] + " material-icons-outlined #{color}"

    tag.button class: (%w{btn btn-primary btn-action} << extra_btn_class) do
      tag.i icon, options
    end
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

  [:tag, :parent].each do |m|
    class_eval %Q{
      def #{m}_autocomplete_url(bit)
        bit.persisted? ? #{m}s_bit_path(bit) : #{m}s_bits_path
      end
    }
  end
end
