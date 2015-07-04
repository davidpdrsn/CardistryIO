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

  describe "#edit" do
    it "requires authentication" do
      get :edit, video_id: 123

      expect(response.status).to eq 302
    end

    it "lets users edit their own videos" do
      bob = create :user
      sign_in_as bob
      video = create :video, user: bob, private: true, approved: true
      get :edit, video_id: video.id

      expect(response.status).to eq 200
    end

    it "doesn't let users edits sharings of others" do
      bob = create :user
      sign_in_as bob
      video = create :video, private: true, approved: true
      get :edit, video_id: video.id

      expect(response.status).to eq 302
    end

    it "only works if video is private" do
      bob = create :user
      sign_in_as bob
      video = create :video, user: bob, private: false, approved: true
      get :edit, video_id: video.id

      expect(response.status).to eq 302
    end

    it "requires the video to be approved" do
      bob = create :user
      sign_in_as bob
      video = create :video, user: bob, private: true, approved: false
      get :edit, video_id: video.id

      expect(response.status).to eq 302
    end
  end

  describe "#destroy" do
    it "unshares the video" do
      alice = create :user
      bob = create :user
      sign_in_as bob
      video = create :video, user: bob, private: true, approved: true
      sharing = Sharing.create!(user: alice, video: video)

      expect do
        delete :destroy, video_id: video.id, id: sharing.id
      end.to change { Sharing.count }.by(-1)
    end

    it "requires authentication" do
      alice = create :user
      bob = create :user
      video = create :video, user: bob, private: true, approved: true
      sharing = Sharing.create!(user: alice, video: video)

      expect do
        delete :destroy, video_id: video.id, id: sharing.id
      end.not_to change { Sharing.count }
    end

    it "requires the user owns the video" do
      alice = create :user
      bob = create :user
      video = create :video, user: bob, private: true, approved: true
      sign_in_as alice
      sharing = Sharing.create!(user: alice, video: video)

      expect do
        delete :destroy, video_id: video.id, id: sharing.id
      end.not_to change { Sharing.count }
    end
  end
end
