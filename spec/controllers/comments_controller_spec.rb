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
        post :create, params: { comment: attributes }.merge!(move_id: move.id)
      end.to change { Comment.count }.by(1)
    end

    it "requires authentication" do
      attributes = attributes_for :comment
      attributes.delete(:commentable_type)
      attributes.delete(:commentable_id)
      move = create :move

      expect do
        post :create, params: { comment: attributes }.merge!(move_id: move.id)
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

      post :create, params: { comment: attributes }.merge!(move_id: move.id)

      expect(Notification.count).to eq 1
      notification = Notification.last
      expect(notification.user).to eq bob
      expect(notification.notification_type).to eq "comment"
      expect(notification.subject.commentable).to eq move
      expect(notification.actor).to eq alice
    end

    it "doesn't create notifications when actor and user are eq" do
      bob = create :user
      sign_in_as(bob)
      attributes = attributes_for :comment
      attributes.delete(:commentable_type)
      attributes.delete(:commentable_id)
      move = create :move, user: bob

      post :create, params: { comment: attributes }.merge!(move_id: move.id)

      expect(Notification.count).to eq 0
    end
  end

  describe "#destroy" do
    it "requires authentication" do
      move = create :move
      comment = create :comment, commentable: move

      delete :destroy, params: { id: comment.id, move_id: move.id }

      expect(response.status).to eq 302
    end

    it "destroys the comment" do
      move = create :move
      comment = create :comment, commentable: move
      sign_in_as comment.user

      expect do
        delete :destroy, params: { id: comment.id, move_id: move.id, format: :js }
        move.reload
      end.to change { move.comments.count }.from(1).to(0)
    end

    it "doesn't allow destruction of other users' comments" do
      move = create :move
      comment = create :comment, commentable: move
      sign_in_as create(:user)

      delete :destroy, params: { id: comment.id, move_id: move.id }

      expect(response.status).to eq 302
    end
  end
end
