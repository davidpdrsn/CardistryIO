module ApplicationHelper
    # Detects the current route and appends the active-nav-item class if the same one gets passed in
    def cp(path)
        current_route = Rails.application.routes.recognize_path(path)
        "active-nav-item" if current_page?(path) or params[:controller] == current_route[:controller]
    end
end
