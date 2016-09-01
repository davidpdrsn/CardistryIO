class Notifier
  pattr_initialize :user_to_notify

  def video_approved(video:, admin_approving:)
    return if video.user == admin_approving
    send_notification(subject: video, actor: admin_approving, type: :video_approved)
  end

  def comment(comment:, commentor:)
    return if comment.commenting_on_own_commentable?
    send_notification(subject: comment, actor: commentor, type: :comment)
  end

  def new_follower(relationship:)
    send_notification(
      subject: SubjectRelationshipAdapter.new(relationship),
      actor: relationship.follower,
      type: :new_follower
    )
  end

  def video_shared(subject:, actor:)
    send_notification(
      subject: subject,
      actor: actor,
      type: :video_shared
    )
  end

  def mentioned(subject:, actor:)
    send_notification(
      subject: subject,
      actor: actor,
      type: :mentioned
    )
  end

  def new_credit(subject:, actor:)
    send_notification(
      subject: subject,
      actor: actor,
      type: :new_credit
    )
  end

  private

  def send_notification(subject:, actor:, type:)
    notification = Notification.create!(
      user: user_to_notify,
      notification_type: type,
      actor: actor,
      subject: subject,
    )
    deliver_notification_via_email(notification)
    notification
  end

  def deliver_notification_via_email(notification)
    return unless notification.user.admin? && notification.deliver_mail_now?
    NotificationMailer.new_notification(notification).deliver_later
  end

  class SubjectRelationshipAdapter < SimpleDelegator
    class << self
      def method_missing(name, *args, &block)
        Relationship.send(name, *args, &block)
      end
    end

    def user
      followee
    end
  end
end
