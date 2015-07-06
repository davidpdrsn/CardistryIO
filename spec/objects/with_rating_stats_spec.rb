require "rails_helper"

describe WithRatingStats do
  describe "#average_rating" do
    it "returns the average rating" do
      rateable = double(
        "rateable",
        ratings: [
          double("rating", rating: 5),
          double("rating", rating: 1),
        ],
      )

      expect(WithRatingStats.new(rateable).average_rating).to eq 3.0
    end

    it "rounds to one decimal place" do
      rateable = double(
        "rateable",
        ratings: [
          double("rating", rating: 2),
          double("rating", rating: 2),
          double("rating", rating: 3),
        ],
      )

      expect(WithRatingStats.new(rateable).average_rating).to eq 2.3
    end

    it "returns 0 when there are no ratings" do
      rateable = double(
        "rateable",
        ratings: [],
      )

      expect(WithRatingStats.new(rateable).average_rating).to eq 0
    end
  end
end
