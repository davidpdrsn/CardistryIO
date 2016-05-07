require "rails_helper"

describe "searching for users" do
  it "returns the users that matches" do
    create :user, username: "Sybil"
    user = create :user, username: "MockingBird"
    create :user, username: "Jackson5"

    get "/api/search/users", params: { query: "Bird" }

    json = JSON.parse(response.body)

    expect(json).to eq [{ "username" => "MockingBird" }]
  end
end
