class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true
  belongs_to :actor, class_name: "User"

  validates :subject, :actor, presence: true

  validates_with(
    PolymorphicAssociationForEnumValuesValidator.new(
      name: :subject,
      enum_column: :notification_type,
      types: {
        "comment" => [Comment],
        "video_approved" => [Video],
        "new_follower" => [Relationship],
        "video_shared" => [Video],
        "mentioned" => [Video, Comment, Move],
        "new_credit" => [Video, Move],
        "featured" => [Video],
      }
    )
  )

  enum notification_type: [
    :comment,
    :video_approved,
    :new_follower,
    :video_shared,
    :mentioned,
    :new_credit,
    :featured,
  ]

  def text
    text = case notification_type
           when "comment"
             "New comment on #{subject.commentable.name} by @#{actor.username}"
           when "video_approved"
             "Your video #{subject.name} has been approved"
           when "new_follower"
             "@#{actor.username} started following you"
           when "video_shared"
             "@#{actor.username} shared a video with you"
           when "mentioned"
             "@#{actor.username} mentioned you in a {{link}}"
           when "new_credit"
             "@#{actor.username} credited you for his {{link}}"
           when "featured"
             "Your video #{subject.name} has been featured"
           else
             fail "No text for notifications of type #{notification_type}"
           end

    StringWithPlaceholders.new(text)
  end

  def expanded_text
    text.expand(link: subject.class.name.downcase).html_safe
  end

  def subject_for_link
    if notification_type == "new_follower"
      subject.follower
    else
      subject.try(:commentable) || subject
    end
  end

  def seen!
    update!(seen: true)
  end

  def deliver_mail_now?
    user.email_frequency == "immediately"
  end
end
