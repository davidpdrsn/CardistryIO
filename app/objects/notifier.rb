class Notifier
  pattr_initialize :user_to_notify

  def video_approved(subject:, actor:)
    send_notification(subject: subject, actor: actor, type: :video_approved)
  end

  def comment(subject:, actor:)
    send_notification(subject: subject, actor: actor, type: :comment)
  end

  def new_follower(subject:, actor:)
    send_notification(
      subject: SubjectRelationshipAdapter.new(subject),
      actor: actor,
      type: :new_follower
    )
  end

  def video_shared(subject:, actor:)
    send_notification_without_checking_subject_actor_relationship(
      subject: subject,
      actor: actor,
      type: :video_shared
    )
  end

  def mentioned(subject:, actor:)
    send_notification_without_checking_subject_actor_relationship(
      subject: subject,
      actor: actor,
      type: :mentioned
    )
  end

  def new_credit(subject:, actor:)
    send_notification_without_checking_subject_actor_relationship(
      subject: subject,
      actor: actor,
      type: :new_credit
    )
  end

  private

  def send_notification_without_checking_subject_actor_relationship(subject:, actor:, type:)
    notification = Notification.create!(
      user: user_to_notify,
      notification_type: type,
      actor: actor,
      subject: subject,
    )
    deliver_notification_via_email(notification)
    notification
  end

  def send_notification(subject:, actor:, type:)
    return if subject.user == actor
    send_notification_without_checking_subject_actor_relationship(
      subject: subject,
      actor: actor,
      type: type,
    )
  end

  def deliver_notification_via_email(notification)
    return unless notification.user.admin? && notification.new_follower?
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
