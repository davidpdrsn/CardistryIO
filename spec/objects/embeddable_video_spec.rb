require "rails_helper"

describe EmbeddableVideo do
  def stubbed_video(options)
    double(
      "video",
      { from_instagram?: false }.merge!(options)
    )
  end

  context "youtube" do
    it "turns a /watch url into a /embed url" do
      obj = stubbed_video(
        url: "https://www.youtube.com/watch?v=x2O5NB8X-a4",
      )

      video = EmbeddableVideo.new(obj)

      expect(video.url).to eq "https://www.youtube.com/embed/x2O5NB8X-a4"
    end

    it "doesn't change urls that are already embeddable" do
      obj = stubbed_video(
        url: "https://www.youtube.com/embed/x2O5NB8X-a4",
      )

      video = EmbeddableVideo.new(obj)

      expect(video.url).to eq "https://www.youtube.com/embed/x2O5NB8X-a4"
    end

    it "supports autoplay" do
      obj = stubbed_video(
        url: "https://www.youtube.com/watch?v=x2O5NB8X-a4",
      )

      video = EmbeddableVideo.new(obj, autoplay: true)

      expect(video.url)
        .to eq "https://www.youtube.com/embed/x2O5NB8X-a4?autoplay=1"
    end

    it "supports time offset" do
      obj = stubbed_video(
        url: "https://www.youtube.com/watch?v=x2O5NB8X-a4",
      )

      video = EmbeddableVideo.new(obj, start: 20)

      expect(video.url)
        .to eq "https://www.youtube.com/embed/x2O5NB8X-a4?start=20"
    end

    it "supports time offset and autoplay" do
      obj = stubbed_video(
        url: "https://www.youtube.com/watch?v=x2O5NB8X-a4",
      )

      video = EmbeddableVideo.new(obj, autoplay: true, start: 20)

      expect(video.url)
        .to eq "https://www.youtube.com/embed/x2O5NB8X-a4?autoplay=1&start=20"
    end
  end

  context "vimeo" do
    it "turn a watch url into an embed url" do
      obj = stubbed_video(
        url: "https://vimeo.com/132077814",
      )

      video = EmbeddableVideo.new(obj)

      expect(video.url).to eq "https://player.vimeo.com/video/132077814"
    end

    it "doesn't change urls that are already embeddable" do
      obj = stubbed_video(
        url: "https://player.vimeo.com/video/132077814",
      )

      video = EmbeddableVideo.new(obj)

      expect(video.url).to eq "https://player.vimeo.com/video/132077814"
    end

    it "supports autoplay" do
      obj = stubbed_video(
        url: "https://vimeo.com/132077814",
      )

      video = EmbeddableVideo.new(obj, autoplay: true)

      expect(video.url).to eq "https://player.vimeo.com/video/132077814?autoplay=1"
    end

    it "supports start time offset" do
      obj = stubbed_video(
        url: "https://vimeo.com/132077814",
      )

      video = EmbeddableVideo.new(obj, start: "121")

      expect(video.url).to eq "https://player.vimeo.com/video/132077814#t=2m1s"
    end

    it "supports autoplay and start time" do
      obj = stubbed_video(
        url: "https://vimeo.com/132077814",
      )

      video = EmbeddableVideo.new(obj, autoplay: true, start: 121)

      expect(video.url).to eq "https://player.vimeo.com/video/132077814#t=2m1s?autoplay=1"
    end
  end

  context "instagram" do
    it "doesn't touch the url" do
      url = "https://scontent.cdninstagram.com/hphotos-xaf1/t50.2886-16/11243245_1599951966956675_1378908578_s.mp4"
      obj = stubbed_video(
        url: url,
      )

      video = EmbeddableVideo.new(obj)

      expect(video.url).to eq url
    end
  end

  it "raises an exception if url isn't valid" do
    obj = stubbed_video(
      url: "lol",
    )

    video = EmbeddableVideo.new(obj)

    expect do
      video.url
    end.to raise_error EmbeddableVideo::UnsupportedHost
  end

  it "raises an exception if host is unsupported" do
    obj = stubbed_video(
      url: "http://example.com/123",
    )

    video = EmbeddableVideo.new(obj)

    expect do
      video.url
    end.to raise_error EmbeddableVideo::UnsupportedHost
  end
end
