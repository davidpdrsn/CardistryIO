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

  describe "#update" do
    let(:move) { create :move }

    it "updates comments" do
      comment = create :comment, commentable: move, content: "old"
      sign_in_as comment.user

      expect do
        patch(
          :update,
          comment: { content: "new" },
          id: comment.id,
          move_id: move.id,
        )
        comment.reload
      end.to change { comment.content }.from("old").to("new")
    end

    it "requires authentication" do
      patch(
        :update,
        comment: { content: "new" },
        id: 123,
        move_id: 123,
      )

      expect(response.status).to eq 302
    end

    it "only updates if changes are valid" do
      comment = create :comment, commentable: move

      expect do
        patch :update, move_id: move.id, comment: { content: "" }, id: comment.id
        comment.reload
      end.to_not change { comment.content }
    end

    it "doesn't update other peoples comments" do
      comment = create :comment, commentable: move, content: "old"
      sign_in_as create(:user)

      expect do
        patch(
          :update,
          comment: { content: "new" },
          id: comment.id,
          move_id: move.id,
        )
        comment.reload
      end.not_to change { comment.content }
    end
  end
end
