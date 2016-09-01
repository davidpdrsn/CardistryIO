class NotificationMailer < ApplicationMailer
  def new_notification(notification)
    @notification = notification
    mail(
      to: notification.user.email,
      subject: "@#{notification.actor.username} is now following you on cardistry.io",
    )
  end
end
