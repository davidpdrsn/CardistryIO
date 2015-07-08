class Notifier
  pattr_initialize :user_to_notify

  def video_approved(subject:, actor:)
    send_notification(subject: subject, actor: actor, type: :video_approved)
  end

  def comment(subject:, actor:)
    send_notification(subject: subject, actor: actor, type: :comment)
  end

  private

  def send_notification(subject:, actor:, type:)
    return if subject.user == actor

    Notification.create!(
      user: user_to_notify,
      type: NotificationType.send(type),
      actor: actor,
      subject: subject,
    )
  end
end
