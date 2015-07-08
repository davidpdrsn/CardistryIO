require "rails_helper"

describe "videos/all.haml" do
  it "shows the videos" do
    video = build_stubbed :video
    assign :videos, [video]

    render

    expect(rendered).to match video.name
  end

  it "shows when there are no videos" do
    assign :videos, []

    render

    expect(rendered).to match "There are no videos, yet"
  end
end
