class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: true
  belongs_to :actor, class_name: "User"
  belongs_to :type, class_name: "NotificationType"

  def text
    "New comment on #{subject.name} by #{actor.username}"
  end

  def seen!
    update!(seen: true)
  end
end
