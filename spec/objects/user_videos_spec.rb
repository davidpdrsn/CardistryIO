require "rails_helper"

describe UserVideos do
  it "enumerates the users approved videos" do
    user = create :user
    video = create :video, user: user, approved: true
    create :video, user: user, approved: false
    create :video, approved: true
    create :video, approved: false

    videos = UserVideos.new(user).inject([]) do |acc, video|
      acc << video
    end

    expect(videos).to eq [video]
  end

  describe "present?" do
    let(:user) { create :user }

    it "is true if the user has approved videos" do
      create :video, approved: true, user: user
      expect(UserVideos.new(user).present?).to eq true
    end

    it "is false if the user has no approved videos" do
      create :video, approved: false, user: user
      expect(UserVideos.new(user).present?).to eq false
    end
  end
end
