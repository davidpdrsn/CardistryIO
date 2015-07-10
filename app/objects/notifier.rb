class Notifier
  pattr_initialize :user_to_notify

  def video_approved(subject:, actor:)
    send_notification(subject: subject, actor: actor, type: :video_approved)
  end

  def comment(subject:, actor:)
    send_notification(subject: subject, actor: actor, type: :comment)
  end

  def new_follower(subject:, actor:)
    send_notification(subject: SubjectRelationshipAdapter.new(subject), actor: actor, type: :new_follower)
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
