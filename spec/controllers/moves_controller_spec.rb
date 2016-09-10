require "rails_helper"

describe MovesController do
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
          post :create, params: { move: attributes_for(:move) }
        }.to change { Move.count }.by 1
      end

      it "doesn't create the move if its invalid" do
        sign_in

        expect {
          post :create, params: { move: { name: "" } }
        }.to change { Move.count }.by 0
      end

      def sign_in
        user = create :user
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

      creditor = instance_double("AddsCredits")
      allow(creditor).to receive(:add_credits)
        .with([bob.username]).and_return([])
      allow(AddsCredits).to receive(:new).with(any_args)
        .and_return(creditor)

      post(:create, params: {
        move: attributes,
        credits: [bob.username],
      })

      expect(creditor).to have_received(:add_credits)
        .with([bob.username])
    end

    it "only creates the credits if the move is valid" do
      user = create :user
      sign_in_as user
      attributes = attributes_for(:move)
      attributes.delete(:name)
      bob = create :user, username: "bob"
      alice = create :user, username: "alice"

      creditor = instance_double("AddsCredits")
      allow(creditor).to receive(:add_credits)
        .and_raise(ActiveRecord::ActiveRecordError)
      allow(AddsCredits).to receive(:new).with(kind_of(Move))
        .and_return(creditor)

      post(:create, params: {
        move: attributes,
        credits: [],
      })

      expect(Move.count).to eq 0
    end
  end

  describe "#destroy" do
    it "deletes the move" do
      move = create :move
      sign_in_as(move.user)

      expect {
        delete :destroy, params: { id: move.id }
      }.to change { Move.all.count }.by -1
    end

    it "only allows deletion of own moves" do
      user = create :user
      move = create :move
      sign_in_as(user)

      expect {
        delete :destroy, params: { id: move.id }
      }.not_to change { Move.all.count }

      expect(controller).to set_flash[:alert]
    end

    it "requires authentication" do
      delete :destroy, params: { id: 1337 }
      expect(response.status).to eq 302
    end
  end

  describe "#edit" do
    it "requires authentication" do
      get :edit, params: { id: 1337 }
      expect(response.status).to eq 302
    end

    it "only the user to edit their own moves" do
      sign_in_as(create :user)
      get :edit, params: { id: create(:move).id }
      expect(response.status).to eq 302
    end
  end

  describe "#update" do
    it "updates the move" do
      move = create :move, name: "Mocking Bird"
      sign_in_as(move.user)

      patch :update, params: { id: move.id, move: { name: "Sybil" } }

      expect(Move.find(move.id).name).to eq "Sybil"
    end

    it "doesn't update the move if its invalid" do
      move = create :move, name: "Mocking Bird"
      sign_in_as(move.user)

      patch :update, params: { id: move.id, move: { name: nil } }

      expect(Move.find(move.id).name).to eq "Mocking Bird"
    end

    it "requires authentication" do
      patch :update, params: { id: 1337 }
      expect(response.status).to eq 302
    end

    it "only the user to edit their own moves" do
      sign_in_as(create :user)
      patch :update, params: { id: create(:move).id }
      expect(response.status).to eq 302
    end

    it "delegates to AddsCredits" do
      move = create :move, name: "Mocking Bird"
      sign_in_as(move.user)
      bob = create :user, username: "bob"

      creditor = instance_double("AddsCredits")
      allow(creditor).to receive(:update_credits)
        .with([bob.username]).and_return([])
      allow(AddsCredits).to receive(:new).with(move)
        .and_return(creditor)

      patch(:update, params: {
        id: move.id,
        move: { name: "Sybil" },
        credits: [bob.username],
      })

      expect(creditor).to have_received(:update_credits)
        .with([bob.username])
    end

    it "keeps the credits if something goes wrong" do
      move = create :move, name: "Mocking Bird"
      sign_in_as(move.user)
      bob = create :user, username: "bob"

      creditor = instance_double("AddsCredits")
      allow(creditor).to receive(:update_credits)
        .and_raise(ActiveRecord::ActiveRecordError)
      allow(AddsCredits).to receive(:new).with(move)
        .and_return(creditor)

      expect do
        patch(:update, params: {
          id: move.id,
          move: { name: "Sybil" },
          credits: [bob.username],
        })
        move.reload
      end.to_not change { move.credits }
    end
  end
end
