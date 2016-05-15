require "rails_helper"

describe "videos/index.haml" do
  it "shows when there are no videos" do
    assign :paged_videos, []

    render

    expect(rendered).to match "You have no videos, yet"
  end
end
