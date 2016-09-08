require "rails_helper"

describe VideoWithUrlHint do
  it "returns a normal hint if there are no errors" do
    video = VideoWithUrlHint.new(build(:video))

    expect(video.url_hint).to eq "Videos from YouTube and Vimeo are supported."
  end

  it "returns a normal hint if there are no errors" do
    model = build :video, url: "example.com"
    model.valid?
    video = VideoWithUrlHint.new(model)

    expect(video.url_hint).to eq "This link is unsupported, only videos from YouTube and Vimeo are allowed."
  end
end
