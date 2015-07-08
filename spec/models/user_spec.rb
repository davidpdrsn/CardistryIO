require "rails_helper"

describe User do
  it { should have_many :moves }
  it { should have_many :videos }
  it { should have_many :comments }
  it { should have_many :ratings }
  it { should have_many :notifications }
  it { should have_many :relationships }

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

  describe "#new_notifications" do
    it "returns the unseen notifications" do
      bob = create :user
      notification = create :notification, seen: false, user: bob
      create :notification, seen: true, user: bob

      expect(bob.new_notifications).to eq [notification]
    end
  end

  describe "#follow!" do
    it "follows a user" do
      bob = create :user
      alice = create :user

      bob.follow!(alice)

      expect(bob.follows?(alice)).to eq true
    end

    it "doesn't follow a user twice" do
      bob = create :user
      alice = create :user

      2.times { bob.follow!(alice) }

      expect(Relationship.count).to eq 1
    end
  end

  describe "#following" do
    it "returns the users following" do
      bob = create :user
      alice = create :user
      create :user

      bob.follow!(alice)

      expect(bob.following.map(&:id)).to eq [alice.id]
    end
  end

  describe "#unfollow!" do
    it "unfollows the user" do
      bob = create :user
      alice = create :user

      bob.follow!(alice)
      bob.unfollow!(alice)

      expect(bob.following).to eq []
    end
  end

  describe "#followers" do
    it "returns the user's followers" do
      bob = create :user
      alice = create :user

      bob.follow!(alice)

      expect(alice.followers).to eq [bob]
    end
  end
end
