class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: true
  belongs_to :actor, class_name: "User"
  belongs_to :type, class_name: "NotificationType"

  def text
    case type.name
    when "comment"
      "New comment on #{subject.name} by @#{actor.username}"
    when "video_approved"
      "Your video #{subject.name} has been approved"
    when "new_follower"
      "@#{actor.username} started following you"
    else
      fail "Unknown notification type"
    end
  end

  def seen!
    update!(seen: true)
  end
end
