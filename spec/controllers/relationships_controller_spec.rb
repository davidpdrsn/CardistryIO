require "rails_helper"

describe RelationshipsController do
  describe "#create" do
    it "requires authentication" do
      post :create, id: 123

      expect(response.status).to eq 302
    end

    it "follows users" do
      bob = create :user
      alice = create :user
      sign_in_as bob

      post :create, id: alice.id

      expect(bob.follows?(alice)).to eq true
    end
  end

  describe "#destroy" do
    it "requires authentication" do
      delete :destroy, id: 123

      expect(response.status).to eq 302
    end

    it "unfollows users" do
      bob = create :user
      alice = create :user
      bob.follow!(alice)
      sign_in_as bob

      delete :destroy, id: alice.id

      expect(bob.follows?(alice)).to eq false
    end
  end
end
