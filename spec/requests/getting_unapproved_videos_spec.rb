require "rails_helper"

describe "getting unapproved video" do
  it "returns the videos" do
    one = create :video, approved: false
    two = create :video, approved: true
    three = create :video, approved: false

    http_login
    authorized_get "/api/videos/unapproved"

    expect(response.status).to eq 200

    json = JSON.parse(response.body).sort_by { |video| video["id"] }
    expect(json.count).to eq 2
    expect(json[0]["id"]).to eq one.id
    expect(json[0]["name"]).to eq one.name
    expect(json[1]["id"]).to eq three.id
    expect(json[1]["name"]).to eq three.name
  end

  it "requires authentication" do
    get "/api/videos/unapproved"

    expect(response.status).to eq 401
  end
end
