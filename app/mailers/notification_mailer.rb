class NotificationMailer < ApplicationMailer
  def new_notification(notification)
    @notification = notification

    mail(
      to: notification.user.email,
      subject: @notification.text,
    )
  end
end
