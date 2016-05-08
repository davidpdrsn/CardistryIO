require "rails_helper"

describe Notification do
  it { should belong_to :user }
  it { should belong_to :subject }
  it { should belong_to :actor }

  describe "#text" do
    context "comment" do
      it "returns the text for that type" do
        commentable = create :video
        bob = create :user

        text = Notification.create!(
          user: commentable.user,
          notification_type: :comment,
          actor: bob,
          subject: commentable,
        ).text

        expect(text.expand).to eq "New comment on #{commentable.name} by @#{bob.username}"
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
end
