require "rails_helper"

describe Admin::ApproveVideosController do
  describe "#new" do
    it "requires authentication" do
      get :new

      expect(response.status).to eq 302
    end

    it "lets admins see the page" do
      admin = create :user, admin: true
      sign_in_as(admin)

      get :new

      expect(response.status).to eq 200
    end

    it "doesn't let non-admins see the page" do
      user = create :user, admin: false
      sign_in_as(user)

      get :new

      expect(response.status).to eq 302
    end
  end

  describe "#create" do
    it "approves the video" do
      admin = create :user, admin: true
      video = create :video, approved: false, user: admin
      allow(Video).to receive(:find).with(video.id.to_s)
        .and_return(video)
      allow(video).to receive(:approve!)
      sign_in_as(admin)

      post :create, params: { id: video.id }

      expect(video).to have_received(:approve!)
    end

    it "requires authentication" do
      post :create, params: { id: 1337 }

      expect(response.status).to eq 302
    end

    it "doesn't let non-admins see the page" do
      user = create :user, admin: false
      sign_in_as(user)

      post :create, params: { id: 1337 }

      expect(response.status).to eq 302
    end
  end

  describe "#destroy" do
    it "deletes the video" do
      admin = create :user, admin: true
      video = create :video, approved: false, user: admin
      allow(Video).to receive(:find).with(video.id.to_s)
        .and_return(video)
      allow(video).to receive(:destroy)
      sign_in_as(admin)

      delete :destroy, params: { id: video.id }

      expect(video).to have_received(:destroy)
    end

    it "requires authentication" do
      delete :destroy, params: { id: 1337 }

      expect(response.status).to eq 302
    end

    it "doesn't let non-admins see the page" do
      user = create :user, admin: false
      sign_in_as(user)

      delete :destroy, params: { id: 1337 }

      expect(response.status).to eq 302
    end
  end
end
