require "rails_helper"

describe NotificationMailer do
  it "comment" do
    huron = create :user, username: "huron"
    daren = create :user, username: "daren"
    video = create :video, user: huron
    comment = create :comment, commentable: video, user: daren

    notification = Notifier.new(huron).comment(
      comment: comment,
      commentor: daren,
    )

    mail = NotificationMailer.new_notification(notification).deliver_now

    expect_email_to_match_notification(mail, notification)
  end

  it "video_approved" do
    huron = create :user, username: "huron"
    video = create :video, user: huron

    notification = Notifier.new(huron).video_approved(
      video: video,
      admin_approving: create(:user),
    )

    mail = NotificationMailer.new_notification(notification).deliver_now

    expect_email_to_match_notification(mail, notification)
  end

  it "new_follower" do
    huron = create :user, username: "huron"
    daren = create :user, username: "daren"

    notification = Notifier.new(huron).new_follower(
      relationship: daren.follow!(huron),
    )

    mail = NotificationMailer.new_notification(notification).deliver_now

    expect_email_to_match_notification(mail, notification)
  end

  def expect_email_to_match_notification(mail, notification)
    expect(mail.subject).to eq notification.text.expand
    expect(mail.body.encoded).to include notification.text.expand
  end
end
