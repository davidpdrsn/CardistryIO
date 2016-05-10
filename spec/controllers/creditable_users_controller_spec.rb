require "rails_helper"

describe CreditableUsersController do
  describe "GET #index" do
    it "requires authentication" do
      move = create :move

      get :index, params: { move_id: move.id }, format: :json

      expect(response.status).to eq 401
    end

    context "for moves" do
      it "finds the creditable users" do
        kevin = create :user, username: "kevin"
        kevin_with_credits = create :user, username: "kevin-with-credits"
        create :user, username: "cindy"
        alice = create :user, username: "alice"
        move = create :move, user: alice
        create :credit, creditable: move, user: kevin_with_credits
        sign_in_as alice

        get :index, params: { move_id: move.id, query: "kevi" }, format: :json

        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        usernames = json.map { |hash| hash["username"] }
        expect(usernames).to eq ["kevin"]
      end

      it "finds the creditable users for new moves" do
        kevin = create :user, username: "kevin"
        create :user, username: "cindy"
        alice = create :user, username: "alice"
        sign_in_as alice

        get :index, params: { query: "kevi" }, format: :json

        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        usernames = json.map { |hash| hash["username"] }
        expect(usernames).to match_array ["kevin"]
      end
    end

    context "for videos" do
      it "finds the creditable users" do
        kevin = create :user, username: "kevin"
        kevin_with_credits = create :user, username: "kevin-with-credits"
        create :user, username: "cindy"
        alice = create :user, username: "alice"
        video = create :video, user: alice
        create :credit, creditable: video, user: kevin_with_credits
        sign_in_as alice

        get :index, params: { video_id: video.id, query: "kevi" }, format: :json

        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        usernames = json.map { |hash| hash["username"] }
        expect(usernames).to eq ["kevin"]
      end

      it "finds the creditable users for new videos" do
        kevin = create :user, username: "kevin"
        create :user, username: "cindy"
        alice = create :user, username: "alice"
        sign_in_as alice

        get :index, params: { query: "kevi" }, format: :json

        json = JSON.parse(response.body)
        expect(response.status).to eq 200
        usernames = json.map { |hash| hash["username"] }
        expect(usernames).to match_array ["kevin"]
      end
    end
  end
end
