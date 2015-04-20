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
  end
end
