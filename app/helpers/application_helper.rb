module ApplicationHelper
  def menu_class(menus, actual_menu_name)
    path = request.fullpath.gsub(/\?.*/, "")

    return "active" if menus[actual_menu_name].to_a.any? { |e| path =~ /^#{e}$/ }

    return "no-active"
  end

  def bootstrap_alert_class(type)
    case type
    when :alert
      "alert alert-danger"
    when :notice
      "mb-2 background-2 box-notification"
    else
      type.to_s
    end
  end

  def render_label(word, palette_name)
    StylePalette::Helper.label(word, palette_name).html_safe
  end

  def render_labels(words, palette_name)
    words.map { |e| render_label e, palette_name }.join(" ").html_safe
  end

  def markdown(text)
    MarkdownRenderer.render(text).html_safe
  end

  def front_user_description(front_user)
    return "Anonymous" if front_user.nil?

    elements = []

    elements << front_user.name_or_anonymous
    elements << front_user.country if front_user.country
    elements << "#{front_user.age} years old" if front_user.age
    elements << front_user.wannabe if front_user.wannabe

    elements.join(", ")
  end

  def card_width_classes(num_cards)
    if num_cards == 1
      "col-sm-12"
    elsif num_cards == 2
      "col-sm-6"
    else
      "col-sm-4"
    end
  end
end
