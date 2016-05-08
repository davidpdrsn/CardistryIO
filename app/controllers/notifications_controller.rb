class NotificationsController < ApplicationController
  before_action :require_login

  def mark_all_read
    current_user.notifications.each(&:seen!)
    flash.notice = "Marked all as read"
    redirect_to root_path
  end
end
