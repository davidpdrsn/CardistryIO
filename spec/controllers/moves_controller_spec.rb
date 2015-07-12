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

    it "creates the move with credits" do
      user = create :user
      sign_in_as user
      attributes = attributes_for(:move)
      bob = create :user, username: "bob"
      alice = create :user, username: "alice"

      post(
        :create,
        move: attributes,
        credits: [bob, alice].map(&:username)
      )

      move = Move.last
      expect(move.creditted_users.map(&:username))
        .to eq [bob, alice].map(&:username)
    end

    it "only creates the credits if the move is valid" do
      user = create :user
      sign_in_as user
      attributes = attributes_for(:move)
      attributes.delete(:name)
      bob = create :user, username: "bob"
      alice = create :user, username: "alice"

      expect do
        post(
          :create,
          move: attributes,
          credits: [bob, alice].map(&:username)
        )
      end.to_not change { Credit.count }
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

  describe "#edit" do
    it "requires authentication" do
      get :edit, id: 1337
      expect(response.status).to eq 302
    end

    it "only the user to edit their own moves" do
      sign_in_as(create :user)
      get :edit, id: create(:move).id
      expect(response.status).to eq 302
    end
  end

  describe "#update" do
    it "updates the move" do
      move = create :move, name: "Mocking Bird"
      sign_in_as(move.user)

      patch :update, id: move.id, move: { name: "Sybil" }

      expect(Move.find(move.id).name).to eq "Sybil"
    end

    it "doesn't update the move if its invalid" do
      move = create :move, name: "Mocking Bird"
      sign_in_as(move.user)

      patch :update, id: move.id, move: { name: nil }

      expect(Move.find(move.id).name).to eq "Mocking Bird"
      expect(controller).to render_template :new
    end

    it "requires authentication" do
      patch :update, id: 1337
      expect(response.status).to eq 302
    end

    it "only the user to edit their own moves" do
      sign_in_as(create :user)
      patch :update, id: create(:move).id
      expect(response.status).to eq 302
    end
  end
end
