module CurrentPathHelper
  def current_path_class(path)
    current_route = Rails.application.routes.recognize_path(path)
    if should_be_highlighted?(path, current_route)
      "active-nav-item"
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
