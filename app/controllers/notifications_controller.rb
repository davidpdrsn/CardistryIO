class NotificationsController < ApplicationController
  before_action :require_login

  def index
    # TODO: Implement this
    render plain: "notifications"
  end

  def mark_all_read
    current_user.notifications.each(&:seen!)
    flash.notice = "Marked all as read"
    redirect_back(fallback_location: root_path)
  end

  def seen
    notification = current_user.notifications.find(params[:id])
    notification.seen!
    redirect_to notification.subject_for_link
  end
end
