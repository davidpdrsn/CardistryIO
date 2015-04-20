require "rails_helper"

describe UsersController do
  describe "#edit" do
    it "requires authentication" do
      get :edit, id: 1
      expect(response.status).to eq 302
    end
  end

  describe "#update" do
    it "requires authentication" do
      patch :update, id: 1
      expect(response.status).to eq 302
    end
  end
end
