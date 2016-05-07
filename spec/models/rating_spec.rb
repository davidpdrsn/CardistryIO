require "rails_helper"

describe Rating do
  it { should belong_to :rateable }
  it { should belong_to :user }

  it { should validate_numericality_of :rating }
  it { should validate_presence_of :user }
  it { should validate_presence_of :rateable }

  describe "validations" do
    it "delegates to UserWithRatingPermissions" do
      video = create :video
      user = create :user
      rating_permissions = instance_double(UserWithRatingPermissions)
      allow(rating_permissions).to receive(:can_rate?).with(video)
      allow(UserWithRatingPermissions).to receive(:new)
        .with(user).and_return(rating_permissions)

      rating = Rating.new(rateable: video, user: user, rating: 2)
      rating.save

      expect(rating_permissions).to have_received(:can_rate?)

      errors = rating.errors.full_messages
      expect(errors.first).to include "Cannot rate"
    end
  end
end
