require "rails_helper"

describe MovesController do
  describe "#index" do
    it "requires authentication" do
      get :index
      expect(response.status).to eq 302
    end
  end

  describe "#new" do
    it "requires authentication" do
      get :new
      expect(response.status).to eq 302
    end
  end

  describe "#create" do
    context "signed_in" do
      it "creates the move" do
        sign_in

        expect {
          post :create, move: attributes_for(:move)
        }.to change { Move.count }.by 1
      end

      it "doesn't create the move if its invalid" do
        sign_in

        expect {
          post :create, move: { name: "" }
        }.to change { Move.count }.by 0
      end

      def sign_in
        user = build_stubbed :user
        sign_in_as user
      end
    end

    it "requires authentication" do
      post :create
      expect(response.status).to eq 302
    end
  end

  describe "#destroy" do
    it "deletes the move" do
      move = create :move
      sign_in_as(move.user)

      expect {
        delete :destroy, id: move.id
      }.to change { Move.all.count }.by -1
    end

    it "only allows deletion of own moves" do
      user = create :user
      move = create :move
      sign_in_as(user)

      expect {
        delete :destroy, id: move.id
      }.not_to change { Move.all.count }

      expect(controller).to set_flash[:alert]
    end

    it "requires authentication" do
      delete :destroy, id: 1337
      expect(response.status).to eq 302
    end
  end
end
