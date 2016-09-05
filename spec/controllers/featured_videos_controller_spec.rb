require "rails_helper"

describe FeaturedVideosController do
  describe "POST #create" do
    it "requires authentication" do
      post :create, params: { id: create(:video).id }

      expect(response.status).to eq 302
    end

    it "requires current_user to be an admin" do
      sign_in_as create(:user)
      video = create :video
      post :create, params: { id: video.id }

      expect(video.reload.featured?).to eq false
    end

    it "notifies the user" do
      sign_in_as create(:user, admin: true)
      user = create :user, admin: true
      video = create :video, user: user

      expect do
        post :create, params: { id: video.id }
      end.to change { video.user.reload.notifications.count }.from(0).to(1)
    end

    it "doesn't notify admins featuring their own videos" do
      user = create(:user, admin: true)
      sign_in_as user
      video = create :video, user: user

      expect do
        post :create, params: { id: video.id }
      end.to_not change { video.user.reload.notifications.count }
    end
  end
end
