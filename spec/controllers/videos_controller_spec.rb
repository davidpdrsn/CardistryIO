require "rails_helper"

describe VideosController do
  describe "#new" do
    it "requires authentication" do
      get :new, video: {}
      expect(response.status).to eq 302
    end
  end

  describe "#create" do
    context "signed in" do
      it "creates the video" do
        user = create :user
        sign_in_as user

        expect {
          post :create, video: attributes_for(:video)
        }.to change { Video.count }.by 1
      end

      it "doesn't create it if its invalid" do
        user = create :user
        sign_in_as user

        expect {
          post :create, video: { name: "" }
        }.to change { Video.count }.by 0
      end
    end

    it "requires authentication" do
      post :create, video: {}
      expect(response.status).to eq 302
    end
  end
end
