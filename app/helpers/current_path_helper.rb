module CurrentPathHelper
  def current_path_class(path)
    current_route = Rails.application.routes.recognize_path(path)
    if should_be_highlighted?(path, current_route)
      "active-nav-item"
    end
  end

  def nav_link(text, path, icon:)
    content_tag :li, class: "nav-item #{current_path_class(path)}" do
      concat(content_tag(:i, nil, class: "icon ion-#{icon}"))
      concat(link_to(text, path))
    end
  end

  private

  def should_be_highlighted?(path, current_route)
    current_page?(path) || controller_action_matches?(current_route)
  end

  def controller_action_matches?(current_route)
    params[:controller] == current_route[:controller] &&
      params[:action] == current_route[:action]
  end
end
