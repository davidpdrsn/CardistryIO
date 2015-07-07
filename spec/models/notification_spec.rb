require "rails_helper"

describe Notification do
  it { should belong_to :user }
  it { should belong_to :subject }
  it { should belong_to :actor }
  it { should belong_to :type }

  describe "#text" do
    context "comment" do
      it "returns the text for that type" do
        commentable = create :video
        bob = create :user

        text = Notification.create!(
          user: commentable.user,
          type: NotificationType.comment,
          actor: bob,
          subject: commentable,
        ).text

        expect(text).to eq "New comment on #{commentable.name} by #{bob.username}"
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
