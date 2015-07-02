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
  end
end
