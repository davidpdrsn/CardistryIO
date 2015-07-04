require "rails_helper"

describe SharingsController do
  describe "#index" do
    it "requires authentication" do
      get :index, video_id: 123

      expect(response.status).to eq 302
    end
  end

  describe "#new" do
    it "requires authentication" do
      get :new, video_id: create(:video).id

      expect(response.status).to eq 302
    end

    it "requires that the user owns the video" do
      sign_in_as create(:user)
      get :new, video_id: create(:video).id

      expect(response.status).to eq 302
    end
  end

  describe "#create" do
    it "requires authentication" do
      post :create, video_id: 123

      expect(response.status).to eq 302
    end

    it "requires the user to own the video" do
      bob = create :user
      video = create :video, user: bob, private: true
      alice = create :user
      cindy = create :user

      sign_in_as alice
      expect do
        post :create, video_id: video.id, sharing: { user: cindy.id }
      end.not_to change { Sharing.count }
    end

    it "requires that the video is private" do
      bob = create :user
      video = create :video, user: bob, private: false
      alice = create :user

      sign_in_as bob
      expect do
        post :create, video_id: video.id, sharing: { user: alice.id }
      end.not_to change { Sharing.count }
    end

    it "doesn't share the video with the same user more than once" do
      bob = create :user
      video = create :video, user: bob, private: true
      alice = create :user

      sign_in_as bob
      expect do
        2.times do
          post :create, video_id: video.id, sharing: { user: alice.id }
        end
      end.to change { Sharing.count }.by(1)
    end
  end
end
