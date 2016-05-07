require "rails_helper"

describe RatingsController do
  it "requires authentication" do
    post :create, move_id: create(:move).id, rating: 1

    expect(response.status).to eq 302
  end
end
