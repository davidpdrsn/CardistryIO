class MentionNotifier
  pattr_initialize :subject

  def notify_mentioned_users
    html_with_mentions = LinkMentions.new(subject.description).link_mentions
    html_with_mentions.users_mentioned.each do |user|
      notify_of_mention(user, subject)
    end
  end

  class CommentAdapter < ActiveRecordDecorator
    def self.method_missing(name, *args, &block)
      Comment.send(name, *args, &block)
    end

    def description
      content
    end
  end

  private

  def notify_of_mention(user, subject)
    return if notification_already_delivered(user, subject)
    return if user == subject.user

    Notifier.new(user).mentioned(
      actor: subject.user,
      subject: subject,
    )
  end

  def notification_already_delivered(user, subject)
    Notification.where(
      user: user,
      subject: subject,
      notification_type: :mentioned,
      actor: subject.user,
    ).present?
  end
end
