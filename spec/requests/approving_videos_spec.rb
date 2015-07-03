require "rails_helper"

describe "approving videos" do
  it "approves videos" do
    video = create :video, approved: false
    http_login

    authorized_post "/api/videos/#{video.id}/approve"
    video.reload

    expect(response.status).to eq 200
    expect(video.approved).to eq true
  end

  it "requires authentication" do
    video = create :video, approved: false

    post "/api/videos/#{video.id}/approve"
    video.reload

    expect(response.status).to eq 401
    expect(video.approved).to eq false
  end
end
