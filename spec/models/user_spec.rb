require "rails_helper"

describe User do
  it { should have_many :moves }
  it { should have_many :videos }
  it { should have_many :comments }
  it { should have_many :ratings }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :encrypted_password }
  it { should validate_presence_of :username }

  it "validates uniquess of username" do
    bob = create :user

    expect do
      create :user, username: bob.username
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "validates uniquess of instagram_username" do
    bob = create :user

    expect do
      create :user, instagram_username: bob.instagram_username
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "is not admin by default" do
    expect(User.new.admin?).to eq false
  end

  describe "#already_rated?" do
    it "returns true if already reated" do
      bob = create :user
      video = create :video
      Rating.create!(rateable: video, user: bob, rating: 2)

      expect(bob.already_rated?(video, type: "Video")).to eq true
    end

    it "returns false if not rated" do
      bob = create :user
      video = create :video

      expect(bob.already_rated?(video, type: "Video")).to eq false
    end

    it "returns false if just rated another of the same type" do
      bob = create :user
      video = create :video
      Rating.create!(rateable: video, user: bob, rating: 2)
      another_video = create :video

      expect(bob.already_rated?(another_video, type: "Video")).to eq false
    end
  end
end
