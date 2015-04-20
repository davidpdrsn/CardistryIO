require "rails_helper"

describe "videos/index.haml" do
  it "shows the videos" do
    video = build_stubbed :video
    assign :videos, [video]

    render

    expect(rendered).to match video.name
  end

  it "shows when there are no videos" do
    assign :videos, []

    render

    expect(rendered).to match "You have no videos, yet"
  end
end
