class NotificationsController < ApplicationController
  before_action :require_login

  def index
    # TODO: Implement this
    render plain: "notifications"
  end

  def mark_all_read
    current_user.notifications.each(&:seen!)
    flash.notice = "Marked all as read"
    redirect_to root_path
  end
end
