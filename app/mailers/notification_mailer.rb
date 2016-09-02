class NotificationMailer < ApplicationMailer
  def new_notification(notification)
    @notification = notification
    @subject = @notification.expanded_text

    mail(
      to: notification.user.email,
      subject: @subject,
    )
  end
end
