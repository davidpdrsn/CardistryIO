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

  before_filter :prerelease_protection
  def prerelease_protection
    return unless Rails.env.production?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch("PRE_USERNAME") &&
        password == ENV.fetch("PRE_PASSWORD")
    end
  end
end
