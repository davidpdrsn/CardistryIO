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
end
