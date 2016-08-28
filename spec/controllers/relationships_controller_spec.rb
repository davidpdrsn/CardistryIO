require "rails_helper"

describe RelationshipsController do
  describe "#create" do
    it "requires authentication" do
      post :create, params: { id: 123 }

      expect(response.status).to eq 302
    end

    it "follows users" do
      bob = create :user
      alice = create :user
      sign_in_as bob

      post :create, params: { id: alice.id }

      expect(bob.follows?(alice)).to eq true
    end

    it "doesn't follow users multiple times" do
      bob = create :user
      alice = create :user
      sign_in_as bob

      2.times do
        post :create, params: { id: alice.id }
      end

      expect(bob.follows?(alice)).to eq true
    end

    it "creates notifications" do
      bob = create :user
      alice = create :user
      sign_in_as bob

      expect do
        post :create, params: { id: alice.id }
      end.to change { Notification.count }
    end

    it "doesn't create duplicate notifications" do
      bob = create :user
      alice = create :user
      sign_in_as bob

      post :create, params: { id: alice.id }
      delete :destroy, params: { id: alice.id }
      post :create, params: { id: alice.id }

      expect(Notification.count).to eq 1
    end
  end

  describe "#destroy" do
    it "requires authentication" do
      delete :destroy, params: { id: 123 }

      expect(response.status).to eq 302
    end

    it "unfollows users" do
      bob = create :user
      alice = create :user
      bob.follow!(alice)
      sign_in_as bob

      delete :destroy, params: { id: alice.id }

      expect(bob.follows?(alice)).to eq false
    end
  end
end
