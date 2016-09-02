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
      sign_in_as(admin)

      post :create, params: { id: video.id }

      expect(video.reload.approved).to eq true
    end

    it "creates activities for the video" do
      admin = create :user, admin: true
      video = create :video, approved: false, user: admin
      sign_in_as(admin)

      post :create, params: { id: video.id }

      expect(Activity.count).to eq 1
      expect(Activity.first.subject).to eq video
    end

    it "notifies the creddited users" do
      admin = create :user, admin: true
      daren = create :user, username: "daren"
      video = create :video, approved: false, user: admin, private: false
      create :credit, creditable: video, user: daren
      sign_in_as(admin)

      post :create, params: { id: video.id }

      expect(Notification.count).to eq 1
      expect(Notification.first.user).to eq daren
      expect(Notification.first.subject).to eq video
    end

    it "doesn't notify the creddited users if the video is private" do
      admin = create :user, admin: true
      daren = create :user, username: "daren"
      video = create :video, approved: false, user: admin, private: true
      create :credit, creditable: video, user: daren
      sign_in_as(admin)

      post :create, params: { id: video.id }

      expect(Notification.count).to eq 0
    end

    it "doesn't notify mentioned users if video is private" do
      admin = create :user, admin: true
      daren = create :user, username: "daren"
      video = create(
        :video,
        approved: false,
        user: admin,
        description: "@#{daren.username} hi",
        private: true,
      )
      sign_in_as(admin)

      post :create, params: { id: video.id }

      expect(Notification.count).to eq 0
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
