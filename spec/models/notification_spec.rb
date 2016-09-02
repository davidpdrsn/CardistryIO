require "rails_helper"

describe Notification do
  it { should belong_to :user }
  it { should belong_to :subject }
  it { should belong_to :actor }

  it { should validate_presence_of :subject }

  describe "#text" do
    context "comment" do
      it "returns the text for that type" do
        video = create :video
        bob = create :user
        comment = create :comment, commentable: video, user: bob

        text = Notification.create!(
          user: video.user,
          notification_type: :comment,
          actor: bob,
          subject: comment,
        ).text

        expect(text.expand).to eq "New comment on #{video.name} by @#{bob.username}"
      end
    end

    context "video approved" do
      it "returns the text for that type" do
        video = create :video
        bob = create :user

        text = Notification.create!(
          user: bob,
          notification_type: :video_approved,
          actor: bob,
          subject: video,
        ).text

        expect(text.expand).to eq "Your video #{video.name} has been approved"
      end
    end

    context "new follower" do
      it "returns the text for that type" do
        alice = create :user
        bob = create :user
        relationship = alice.follow!(bob)

        text = Notification.create!(
          user: bob,
          notification_type: :new_follower,
          actor: alice,
          subject: relationship,
        ).text

        expect(text.expand).to eq "@#{alice.username} started following you"
      end
    end
  end

  describe "#seen!" do
    it "marks a notification as seen" do
      notification = create :notification

      expect do
        notification.seen!
      end.to change { notification.seen }.from(false).to(true)
    end
  end

  describe "#subject_for_link" do
    it "returns the commentable for comment notifications" do
      video = create :video
      comment = create :comment, commentable: video

      notification = create(
        :notification,
        notification_type: :comment,
        subject: comment,
      )

      expect(notification.subject_for_link).to eq video
    end

    it "returns the commentable for mention notifications" do
      video = create :video
      comment = create :comment, commentable: video

      notification = create(
        :notification,
        notification_type: :mentioned,
        subject: comment,
      )

      expect(notification.subject_for_link).to eq video
    end

    it "returns the follower for new follower notifications" do
      bob = create :user, username: "bob"
      alice = create :user, username: "alice"
      relationship = bob.follow!(alice)

      notification = create(
        :notification,
        notification_type: :new_follower,
        subject: relationship,
      )

      expect(notification.subject_for_link).to eq bob
    end

    it "returns the subject for other notifications" do
      video = create :video

      notification = create(
        :notification,
        notification_type: :video_shared,
        subject: video,
      )

      expect(notification.subject_for_link).to eq video
    end
  end

  describe "#deliver_mail_now?" do
    it "returns true if user wants emails immediately" do
      user = create :user, email_frequency: :immediately
      notification = create :notification, user: user

      expect(notification.deliver_mail_now?).to eq true
    end

    it "returns false if user doesn't want email immediately" do
      user = create :user, email_frequency: :never
      notification = create :notification, user: user

      expect(notification.deliver_mail_now?).to eq false
    end
  end

  describe "validating type of subject" do
    context "video approved" do
      it "is invalid if subject is a move" do
        admin = create :user
        user = create :user
        move = create :move

        expect do
          Notifier.new(user).video_approved(video: move, admin_approving: admin)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "is valid if subject is a video" do
        admin = create :user
        user = create :user
        video = create :video

        expect do
          Notifier.new(user).video_approved(video: video, admin_approving: admin)
        end.to change { Notification.count }.from(0).to(1)
      end
    end
  end
end
