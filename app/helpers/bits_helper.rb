module BitsHelper

  def flowchart_icon(bit, invisible_dummy: true)
    if bit.predecessor.present? || bit.successors.exists?
      link_to flowchart_bit_path(bit), class: %w( flex-center btn btn-action btn-link) do
        tag.i "swap_horiz", class: %w( material-icons-outlined )
      end
    elsif invisible_dummy
      link_to '#', {class: 'btn d-invisible'} do
        tag.i "settings_ethernet", class: %w( material-icons-outlined )
      end
    end
  end

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

  def status_color(bit, prefix: 'text', inverted: false, show_unassigned: false)
    color = "#{prefix}-secondary"

    case bit.status
    when 'unassigned'
      color = (show_unassigned ? "#{prefix}-primary" : 'd-invisible')
    when 'todo'
      color = (inverted ? "#{prefix}-secondary" : "#{prefix}-primary")
    when 'ongoing'
      color = (inverted ? "#{prefix}-secondary" : "#{prefix}-primary")
    when 'waiting'
      color = "#{prefix}-warning"
    when 'completed'
      color = "#{prefix}-success"
    end
  end

  def status_icon(bit, options = {})
    icon = ''
    extra_btn_class = ''

    case bit.status
    when 'unassigned'
      icon = ''
      extra_btn_class = 'd-invisible'
    when 'todo'
      icon = "radio_button_unchecked"
    when 'ongoing'
      icon = "play_circle_outline"
    when 'waiting'
      icon = "pause_circle_outline"
    when 'completed'
      icon = "check_circle"
    end

    color = status_color(bit, inverted: true)
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
