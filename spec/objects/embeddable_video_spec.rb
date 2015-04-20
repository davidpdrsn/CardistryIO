require "rails_helper"

describe EmbeddableVideo do
  it "turns a /watch url into a /embed url" do
    obj = double(
      "video",
      url: "https://www.youtube.com/watch?v=x2O5NB8X-a4",
    )

    video = EmbeddableVideo.new(obj)

    expect(video.url).to eq "https://www.youtube.com/embed/x2O5NB8X-a4"
  end

  it "doesn't change urls that are already embeddable" do
    obj = double(
      "video",
      url: "https://www.youtube.com/embed/x2O5NB8X-a4",
    )

    video = EmbeddableVideo.new(obj)

    expect(video.url).to eq "https://www.youtube.com/embed/x2O5NB8X-a4"
  end
end
