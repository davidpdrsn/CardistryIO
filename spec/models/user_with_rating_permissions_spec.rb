require "rails_helper"

describe UserWithRatingPermissions do
  describe "#can_rate?" do
    it "returns true if the user can rate the video" do
      user = create :user
      video = create :video

      expect(
        UserWithRatingPermissions.new(user).can_rate?(video)
      ).to eq true
    end

    it "returns false if the user has already rated the video" do
      user = create :user
      video = create :video
      video.ratings.create!(user: user, rating: 2)

      expect(
        UserWithRatingPermissions.new(user).can_rate?(video)
      ).to eq false
    end

    it "returns false if the user is attempt to rate own video" do
      user = create :user
      video = create :video, user: user

      expect(
        UserWithRatingPermissions.new(user).can_rate?(video)
      ).to eq false
    end
  end
end
