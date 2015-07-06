require "rails_helper"

describe VideoWithUrlHint do
  it "returns a normal hint if there are no errors" do
    video = VideoWithUrlHint.new(build(:video))

    expect(video.url_hint).to eq "Videos from YouTube, Vimeo, and Instagram are supported"
  end

  it "returns a normal hint if there are no errors" do
    model = build :video, url: "example.com"
    model.valid?
    video = VideoWithUrlHint.new(model)

    expect(video.url_hint).to eq "is unsupported, only videos from YouTube, Vimeo, and Instagram are supported"
  end
end
