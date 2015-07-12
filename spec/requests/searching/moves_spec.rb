require "rails_helper"

describe "searching for moves" do
  it "returns the moves that matches" do
    create :move, name: "Sybil"
    create :move, name: "Mocking Bird"
    create :move, name: "Jackson 5"

    get "/api/search/moves", query: "Bird"

    json = JSON.parse(response.body)

    expect(json).to eq [{ "name" => "Mocking Bird", "credits" => [] }]
  end
end
