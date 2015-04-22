class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    super || NullUser.new
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash.alert = "Page not found"
    redirect_to root_path
  end
end
