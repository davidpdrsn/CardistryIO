module CurrentPathHelper
  def current_path_class(path)
    if should_be_highlighted?(path)
      "active-nav-item"
    end
  end

  def nav_link(text, path, icon:)
    classes = "nav-item #{current_path_class(path)}"

    if text.nil?
      classes += " nav-link-just-icon"
    end

    content_tag :li, class: classes do
      concat content_tag(:i, nil, class: "icon ion-#{icon}")
      concat link_to(text || "", path)
    end
  end

  private

  def should_be_highlighted?(path)
    request.env["PATH_INFO"] == path
  end
end
