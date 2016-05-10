class ApplicationController < ActionController::Base
  include Clearance::Controller
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    super || NullUser.new
  end

  before_action :enable_rack_mini_profiler
  def enable_rack_mini_profiler
    if current_user.admin?
      Rack::MiniProfiler.authorize_request
    end
  end

  def authenticate(params)
    User.authenticate(
      params[:session][:email_or_username],
      params[:session][:password],
    )
  end

  def _buttonbar
    @user = current_user
    @notifications = current_user.notifications
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash.alert = "Page not found"
    redirect_to root_path
  end

  before_action :prerelease_protection
  def prerelease_protection
    return unless Rails.env.production?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch("PRE_USERNAME") &&
        password == ENV.fetch("PRE_PASSWORD")
    end
  end
end
