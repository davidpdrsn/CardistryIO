require "rails_helper"

describe VideoAppearancesController do
  let(:video) { create :video }

  describe "#edit" do
    it "requires authentication" do
      get :edit, params: { id: video.id }

      expect(response.status).to eq 302
    end

    it "only allows editing of own videos" do
      sign_in_as create(:user)

      get :edit, params: { id: video.id }

      expect(response.status).to eq 302
    end
  end

  describe "#update" do
    it "only submits if everything goes well" do
      sign_in_as video.user
      video_appearances = double
      allow(video_appearances).to receive(:save).and_return(false)
      allow(VideoAppearances).to receive(:new).and_return(video_appearances)

      patch(:update, params: {
        id: video.id,
        move_names: ["no_there"],
        minutes: ["0"],
        seconds: ["12"],
      })

      expect(controller).to set_flash[:alert]
    end

    it "resets appearances when submitting empty form" do
      video = create :video
      sign_in_as video.user
      create :appearance, video: video, minutes: 0, seconds: 20

      expect do
        patch(:update, params: {
          id: video.id,
        })
      end.to change { video.reload.appearances.count }.from(1).to(0)
    end

    it "requires authentication" do
      patch :update, params: { id: video.id }

      expect(response.status).to eq 302
    end

    it "only allows editing of own videos" do
      sign_in_as create(:user)

      patch :update, params: { id: video.id }

      expect(response.status).to eq 302
    end
  end

  describe "#destroy" do
    let(:video) { create :video }

    it "destroys all appearances" do
      video = create :video
      move = create :move, user: video.user
      create :appearance, video: video, move: move, minutes: 1, seconds: 1

      sign_in_as video.user
      delete :destroy, params: { id: video.id }

      expect(video.appearances).to eq []
      expect(controller).to redirect_to video
      expect(controller).to set_flash[:notice]
    end

    it "only allows editing of own videos" do
      sign_in_as create(:user)

      delete :destroy, params: { id: video.id }

      expect(response.status).to eq 302
    end

    it "requires authentication" do
      delete :destroy, params: { id: video.id }

      expect(response.status).to eq 302
    end
  end
end
