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
      get :show, id: video.id

      expect(response.status).to eq 200
    end

    it "redirects if video isn't approved" do
      video = create :video, approved: false
      get :show, id: video.id

      expect(response.status).to eq 302
    end
  end

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
        attributes = attributes_for(:video)
        attributes.delete(:approved)

        expect {
          post :create, video: attributes
        }.to change { Video.count }.by 1

        expect(controller).to set_flash[:notice]
        expect(controller).to redirect_to root_path
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

  describe "#destroy" do
    it "deletes the video" do
      video = create :video
      sign_in_as(video.user)

      expect {
        delete :destroy, id: video.id
      }.to change { Video.count }.by -1

      expect(controller).to set_flash[:notice]
    end

    it "requires authentication" do
      delete :destroy, id: 1337
      expect(response.status).to eq 302
    end

    it "requires the user to own the video" do
      video = create :video
      sign_in_as(create :user)

      expect {
        delete :destroy, id: video.id
      }.not_to change { Video.count }

      expect(controller).to set_flash[:alert]
    end
  end

  describe "#edit" do
    it "requires authentication" do
      get :edit, id: 1337
      expect(response.status).to eq 302
    end

    it "only the user to edit their own videos" do
      sign_in_as(create :user)
      get :edit, id: create(:video).id
      expect(response.status).to eq 302
    end
  end

  describe "#update" do
    it "updates the video" do
      video = create :video, name: "Mocking Bird"
      sign_in_as(video.user)

      patch :update, id: video.id, video: { name: "Sybil" }

      expect(Video.find(video.id).name).to eq "Sybil"
    end

    it "doesn't update the video if its invalid" do
      video = create :video, name: "Mocking Bird"
      sign_in_as(video.user)

      patch :update, id: video.id, video: { name: nil }

      expect(Video.find(video.id).name).to eq "Mocking Bird"
      expect(controller).to render_template :new
    end

    it "requires authentication" do
      patch :update, id: 1337
      expect(response.status).to eq 302
    end

    it "only the user to edit their own videos" do
      sign_in_as(create :user)
      patch :update, id: create(:video).id
      expect(response.status).to eq 302
    end
  end
end
