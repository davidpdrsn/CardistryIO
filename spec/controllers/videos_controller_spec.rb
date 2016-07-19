require "rails_helper"

describe VideosController do
  describe "#index" do
    it "requires authentication" do
      get :index

      expect(response.status).to eq 302
    end
  end

  describe "#show" do
    it "shows the video" do
      video = create :video, approved: true

      get :show, params: { id: video.id }

      expect(response.status).to eq 200
    end

    it "redirects if video isn't approved" do
      video = create :video, approved: false

      get :show, params: { id: video.id }

      expect(response.status).to eq 302
    end

    it "doesn't show private videos" do
      video = create :video, approved: true, private: true

      get :show, params: { id: video.id }

      expect(response.status).to eq 302
    end

    it "shows private videos to the user who owns it" do
      video = create :video, approved: true, private: true
      sign_in_as video.user

      get :show, params: { id: video.id }

      expect(response.status).to eq 200
    end

    it "shows private videos shared with current_user" do
      alice = create :user
      video = create :video, approved: true, private: true
      Sharing.create!(video: video, user: alice)
      sign_in_as alice

      get :show, params: { id: video.id }

      expect(response.status).to eq 200
    end
  end

  describe "#new" do
    it "requires authentication" do
      get :new, params: { video: {} }

      expect(response.status).to eq 302
    end
  end

  describe "#create" do
    context "signed in" do
      it "creates the video" do
        user = create :user
        sign_in_as user
        attributes = attributes_for(:video)
        attributes.delete(:approved)

        expect {
          post :create, params: { video: attributes }
        }.to change { Video.count }.by 1

        expect(controller).to set_flash[:notice]
        expect(controller).to redirect_to root_path
      end

      it "doesn't create it if its invalid" do
        user = create :user
        sign_in_as user

        expect {
          post :create, params: { video: { name: "" } }
        }.to change { Video.count }.by 0
      end

      it "creates the video with credits" do
        user = create :user
        sign_in_as user
        attributes = attributes_for(:video)
        attributes.delete(:approved)
        bob = create :user, username: "bob"

        creditor = instance_double("AddsCredits")
        allow(creditor).to receive(:add_credits)
          .with([bob.username]).and_return([])
        allow(AddsCredits).to receive(:new).with(kind_of(Video))
          .and_return(creditor)

        post(:create, params: {
          video: attributes,
          credits: [bob.username]
        })

        expect(creditor).to have_received(:add_credits)
          .with([bob.username])
      end

      it "only creates the credits if the video is valid" do
        user = create :user
        sign_in_as user
        attributes = attributes_for(:video)
        attributes.delete(:name)
        attributes.delete(:approved)
        bob = create :user, username: "bob"
        alice = create :user, username: "alice"

        creditor = instance_double("AddsCredits")
        allow(creditor).to receive(:add_credits)
          .and_raise(ActiveRecord::ActiveRecordError)
        allow(AddsCredits).to receive(:new).with(kind_of(Video))
          .and_return(creditor)

        post(:create, params: {
          video: attributes,
          credits: []
        })

        expect(controller).to set_flash[:alert]
      end
    end

    it "requires authentication" do
      post :create, params: { video: {} }

      expect(response.status).to eq 302
    end

    it "loads the thumbnail" do
      allow(LoadVideoThumbnailJob).to receive(:perform_later)
      user = create :user
      sign_in_as user
      attributes = attributes_for(:video)
      attributes.delete(:approved)

      post :create, params: { video: attributes }

      expect(LoadVideoThumbnailJob).to have_received(:perform_later)
    end
  end

  describe "#destroy" do
    it "deletes the video" do
      video = create :video
      sign_in_as(video.user)

      expect {
        delete :destroy, params: { id: video.id }
      }.to change { Video.count }.by -1

      expect(controller).to set_flash[:notice]
    end

    it "requires authentication" do
      delete :destroy, params: { id: 1337 }

      expect(response.status).to eq 302
    end

    it "requires the user to own the video" do
      video = create :video
      sign_in_as(create :user)

      expect {
        delete :destroy, params: { id: video.id }
      }.not_to change { Video.count }

      expect(controller).to set_flash[:alert]
    end
  end

  describe "#edit" do
    it "requires authentication" do
      get :edit, params: { id: 1337 }

      expect(response.status).to eq 302
    end

    it "only the user to edit their own videos" do
      sign_in_as(create :user)

      get :edit, params: { id: create(:video).id }

      expect(response.status).to eq 302
    end
  end

  describe "#update" do
    it "updates the video" do
      video = create :video, name: "Mocking Bird"
      sign_in_as(video.user)

      patch :update, params: { id: video.id, video: { name: "Sybil" } }

      expect(Video.find(video.id).name).to eq "Sybil"
    end

    it "doesn't update the video if its invalid" do
      video = create :video, name: "Mocking Bird"
      sign_in_as(video.user)

      patch :update, params: { id: video.id, video: { name: nil } }

      expect(Video.find(video.id).name).to eq "Mocking Bird"
    end

    it "requires authentication" do
      patch :update, params: { id: 1337 }

      expect(response.status).to eq 302
    end

    it "only the user to edit their own videos" do
      sign_in_as(create :user)

      patch :update, params: { id: create(:video).id }

      expect(response.status).to eq 302
    end

    it "delegates to AddsCredits" do
      video = create :video, name: "Mocking Bird"
      sign_in_as(video.user)
      bob = create :user, username: "bob"

      creditor = instance_double("AddsCredits")
      allow(creditor).to receive(:update_credits)
        .with([bob.username]).and_return([])
      allow(AddsCredits).to receive(:new).with(video)
        .and_return(creditor)

      patch(:update, params: {
        id: video.id,
        video: { name: "Sybil" },
        credits: [bob.username],
      })

      expect(creditor).to have_received(:update_credits)
        .with([bob.username])
    end

    it "keeps the credits if something goes wrong" do
      video = create :video, name: "Mocking Bird"
      sign_in_as(video.user)
      bob = create :user, username: "bob"

      creditor = instance_double("AddsCredits")
      allow(creditor).to receive(:update_credits)
        .and_raise(ActiveRecord::ActiveRecordError)
      allow(AddsCredits).to receive(:new).with(video)
        .and_return(creditor)

      patch(:update, params: {
        id: video.id,
        video: { name: "Sybil" },
        credits: [bob.username],
      })

      expect(controller).to set_flash[:alert]
    end
  end
end
