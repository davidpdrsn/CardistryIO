require "rails_helper"

describe CommentsController do
  describe "#create" do
    it "creates comments" do
      user = create :user
      sign_in_as(user)
      attributes = attributes_for :comment
      attributes.delete(:commentable_type)
      attributes.delete(:commentable_id)
      move = create :move

      expect do
        post :create, { comment: attributes }.merge!(move_id: move.id)
      end.to change { Comment.count }.by(1)
    end

    it "requires authentication" do
      attributes = attributes_for :comment
      attributes.delete(:commentable_type)
      attributes.delete(:commentable_id)
      move = create :move

      expect do
        post :create, { comment: attributes }.merge!(move_id: move.id)
      end.to_not change { Comment.count }

      expect(response.status).to eq 302
    end

    it "creates notifications" do
      bob = create :user
      alice = create :user
      sign_in_as(alice)
      attributes = attributes_for :comment
      attributes.delete(:commentable_type)
      attributes.delete(:commentable_id)
      move = create :move, user: bob

      post :create, { comment: attributes }.merge!(move_id: move.id)

      expect(Notification.count).to eq 1
      notification = Notification.last
      expect(notification.user).to eq bob
      expect(notification.type).to eq NotificationType.comment
      expect(notification.subject).to eq move
      expect(notification.actor).to eq alice
    end

    it "doesn't create notifications when actor and user are eq" do
      bob = create :user
      sign_in_as(bob)
      attributes = attributes_for :comment
      attributes.delete(:commentable_type)
      attributes.delete(:commentable_id)
      move = create :move, user: bob

      post :create, { comment: attributes }.merge!(move_id: move.id)

      expect(Notification.count).to eq 0
    end
  end
end
