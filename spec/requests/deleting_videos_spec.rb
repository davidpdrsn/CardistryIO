require "rails_helper"

describe "deleting videos" do
  it "approves videos" do
    video = create :video, approved: false
    http_login

    expect do
      authorized_delete "/api/videos/#{video.id}"
    end.to change { Video.all.count }.by(-1)

    expect(response.status).to eq 200
  end

  it "requires authentication" do
    video = create :video, approved: false

    expect do
      authorized_delete "/api/videos/#{video.id}"
    end.not_to change { Video.all.count }

    expect(response.status).to eq 401
  end
end
