require "rails_helper"

describe UsersController do
  describe "#edit" do
    it "requires authentication" do
      get :edit, params: { id: 1 }

      expect(response.status).to eq 302
    end

    it "only allows users to edit their own profile" do
      bob = build_stubbed(:user)
      alice = build_stubbed(:user)
      sign_in_as bob

      get :edit, params: { id: alice.id }

      expect(response.status).to eq 302
    end
  end

  describe "#update" do
    it "requires authentication" do
      patch :update, params: { id: 1 }

      expect(response.status).to eq 302
    end

    it "only allows users to edit their own profile" do
      bob = build_stubbed(:user)
      alice = build_stubbed(:user)
      sign_in_as bob

      patch :update, params: { id: alice.id }

      expect(response.status).to eq 302
    end

    it "redirects if update failed" do
      bob = create :user, username: "Bob"
      create :user, instagram_username: "horse"
      sign_in_as bob

      patch :update, params: { id: bob.id, user: { instagram_username: "horse" } }
      bob.reload

      expect(bob.username).to eq "Bob"
      expect(controller).to set_flash[:alert]
    end

    it "is not possible to update instagram_username" do
      bob = create :user, username: "Bob", instagram_username: "bob"
      sign_in_as bob

      patch :update, params: { id: bob.id, user: { instagram_username: "lol" } }
      bob.reload

      expect(bob.instagram_username).to eq "bob"
    end
  end

  describe "#make_admin" do
    it "requires authentication" do
      post :make_admin, params: { id: 1 }

      expect(response.status).to eq 302
    end

    it "requires current_user to be an admin" do
      bob = create :user, admin: false
      sign_in_as bob

      post :make_admin, params: { id: bob.id }

      expect(response.status).to eq 302
    end

    it "promotes normal users to admin users" do
      bob = create :user, admin: false
      alice = create :user, admin: true
      sign_in_as alice

      post :make_admin, params: { id: bob.id }
      bob.reload

      expect(bob.admin).to eq true
    end
  end
end
