require "rails_helper"

describe NotificationsController do
  it "requires authentication" do
    get :index, params: { user_id: 123 }

    expect(response.status).to eq 302
  end
end
