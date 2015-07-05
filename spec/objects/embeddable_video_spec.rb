require "rails_helper"

describe EmbeddableVideo do
  context "videos from youtube" do
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

  context "videos from vimeo" do
    it "turn a watch url into an embed url" do
      obj = double(
        "video",
        url: "https://vimeo.com/132077814",
      )

      video = EmbeddableVideo.new(obj)

      expect(video.url).to eq "https://player.vimeo.com/video/132077814"
    end

    it "doesn't change urls that are already embeddable" do
      obj = double(
        "video",
        url: "https://player.vimeo.com/video/132077814",
      )

      video = EmbeddableVideo.new(obj)

      expect(video.url).to eq "https://player.vimeo.com/video/132077814"
    end
  end

  it "raises an exception if url isn't valid" do
    obj = double(
      "video",
      url: "lol",
    )

    video = EmbeddableVideo.new(obj)

    expect do
      video.url
    end.to raise_error EmbeddableVideo::UnsupportedHost
  end

  it "raises an exception if host is unsupported" do
    obj = double(
      "video",
      url: "http://example.com/123",
    )

    video = EmbeddableVideo.new(obj)

    expect do
      video.url
    end.to raise_error EmbeddableVideo::UnsupportedHost
  end
end
