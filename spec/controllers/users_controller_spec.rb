require "rails_helper"

describe UsersController do
  describe "#edit" do
    it "requires authentication" do
      get :edit, id: 1
      expect(response.status).to eq 302
    end

    it "only allows users to edit their own profile" do
      bob = build_stubbed(:user)
      alice = build_stubbed(:user)
      sign_in_as bob

      get :edit, id: alice.id

      expect(response.status).to eq 302
    end
  end

  describe "#update" do
    it "requires authentication" do
      patch :update, id: 1
      expect(response.status).to eq 302
    end

    it "only allows users to edit their own profile" do
      bob = build_stubbed(:user)
      alice = build_stubbed(:user)
      sign_in_as bob

      patch :update, id: alice.id

      expect(response.status).to eq 302
    end

    it "redirects if update failed" do
      bob = create :user, first_name: "Bob"
      sign_in_as bob

      patch :update, id: bob.id, user: { first_name: "" }
      bob.reload

      expect(bob.first_name).to eq "Bob"
      expect(controller).to set_flash[:alert]
    end
  end

  describe "#make_admin" do
    it "requires authentication" do
      post :make_admin, id: 1

      expect(response.status).to eq 302
    end

    it "requires current_user to be an admin" do
      bob = create :user, admin: false
      sign_in_as bob
      post :make_admin, id: bob.id

      expect(response.status).to eq 302
    end

    it "promotes normal users to admin users" do
      bob = create :user, admin: false
      alice = create :user, admin: true
      sign_in_as alice

      post :make_admin, id: bob.id
      bob.reload

      expect(bob.admin).to eq true
    end
  end
end
