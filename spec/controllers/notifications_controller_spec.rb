require "rails_helper"

describe NotificationsController do
  describe "GET #show" do
    it "requires authentication" do
      get :show, params: { id: 1 }

      expect(response.status).to eq 302
    end

    it "doesn't allow you mess with other user's notifications" do
      huron = create :user, username: "huron"
      daren = create :user, username: "daren"
      notification = create :notification, user: huron
      sign_in_as daren

      get :show, params: { id: notification.id }

      expect(notification.reload.seen).to eq false
      expect(response).to redirect_to(root_path)
    end
  end
end
