require "rails_helper"

describe Sharing do
  it { should belong_to :user }
  it { should belong_to :video }

  it { should validate_presence_of :video_id }
  it { should validate_presence_of :user_id }

  describe ".videos_shared_with_user" do
    it "returns the videos that have been shared with that user" do
      bob = create :user
      video = create :video, private: true, name: "Air Time"
      create :video, private: true, name: "SHHH!"

      Sharing.create!(video: video, user: bob)

      shared_videos = Sharing.videos_shared_with_user(bob)
      expect(shared_videos.map(&:name)).to eq [video.name]
    end
  end

  it "isn't possible share videos with yourself" do
    user = create :user
    video = create :video, user: user

    sharing = Sharing.new(video: video, user: user)

    expect(sharing.valid?).to eq false
  end
end
