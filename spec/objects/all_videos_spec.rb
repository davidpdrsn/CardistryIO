require "rails_helper"

describe AllVideos do
  it "enumerates all public videos" do
    video = create :video, approved: true
    create :video, approved: true, private: true
    create :video, approved: false

    videos = AllVideos.new.inject([]) do |acc, video|
      acc << video
    end

    expect(videos).to eq [video]
  end

  describe "present?" do
    it "is true if there are approved videos" do
      create :video, approved: true
      expect(AllVideos.new.present?).to eq true
    end

    it "is false if there are no approved videos" do
      create :video, approved: false
      create :video, approved: true, private: true
      expect(AllVideos.new.present?).to eq false
    end
  end
end
