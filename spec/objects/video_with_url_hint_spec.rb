require "rails_helper"

describe VideoWithUrlHint do
  it "returns a normal hint if there are no errors" do
    video = VideoWithUrlHint.new(build(:video))

    expect(video.url_hint).to eq "Videos from Instagram, YouTube, and Vimeo are supported"
  end

  it "returns a normal hint if there are no errors" do
    model = build :video, url: "example.com"
    model.valid?
    video = VideoWithUrlHint.new(model)

    expect(video.url_hint).to eq "is unsupported, only videos from Instagram, YouTube, and Vimeo are supported"
  end
end
