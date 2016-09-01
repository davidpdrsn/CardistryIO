require "rails_helper"

describe User do
  it { should have_many :moves }
  it { should have_many :videos }
  it { should have_many :comments }
  it { should have_many :ratings }
  it { should have_many :notifications }
  it { should have_many :relationships }
  it { should have_many :activities }
  it { should have_many :video_views }
  it { should have_many :credits }

  it { should validate_presence_of :email }
  it { should validate_presence_of :encrypted_password }
  it { should validate_presence_of :username }
  it { should validate_presence_of :time_zone }
  it { should validate_presence_of :country_code }
  it do
    should validate_length_of(:biography).is_at_most(User::BIOGRAPHY_MAX_LENGTH)
  end

  it do
    should validate_inclusion_of(:time_zone)
      .in_array(ActiveSupport::TimeZone.all.map(&:name))
  end

  it do
    should validate_inclusion_of(:country_code)
      .in_array(ISO3166::Country.all.map(&:alpha2))
  end

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

  describe "#follows?" do
    it "returns true if the user is following" do
      bob = create :user
      alice = create :user

      bob.follow!(alice)

      expect(bob.follows?(alice)).to eq true
    end

    it "returns false if the user is not following" do
      bob = create :user
      alice = create :user

      expect(bob.follows?(alice)).to eq false
    end

    it "returns false if the user has unfollowed" do
      bob = create :user
      alice = create :user

      bob.follow!(alice)
      bob.unfollow!(alice)

      expect(bob.follows?(alice)).to eq false
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

    it "reuses old relationships" do
      bob = create :user
      alice = create :user

      bob.follow!(alice)
      bob.unfollow!(alice)
      expect(Relationship.count).to eq 1

      bob.follow!(alice)
      expect(Relationship.count).to eq 1
    end

    it "returns a new relationship the first time" do
      bob = create :user
      alice = create :user

      relationship = bob.follow!(alice)

      expect(relationship.new?).to eq true
    end

    it "returns and old relationship the subsequent times" do
      bob = create :user
      alice = create :user

      bob.follow!(alice)
      bob.unfollow!(alice)
      relationship = bob.follow!(alice)

      expect(relationship.new?).to eq false
    end

    it "returns the old relationship when following someone again" do
      bob = create :user
      alice = create :user

      bob.follow!(alice)
      relationship = bob.follow!(alice)

      expect(relationship.new?).to eq false
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
      cindy = create :user

      bob.follow!(alice)
      cindy.follow!(alice)
      cindy.unfollow!(alice)

      expect(alice.followers).to eq [bob]
    end
  end

  describe "validation of username" do
    it "is valid when it only contains alphanumeric characters and -_" do
      bob = build :user, username: "bob-123__"

      expect(bob).to be_valid
    end

    it "cannot contain spaces" do
      bob = build :user, username: "bob 123"

      expect(bob).not_to be_valid
    end

    it "cannot contain funky characters" do
      bob = build :user, username: "bob:&^!%@&#^D"

      expect(bob).not_to be_valid
    end
  end

  describe ".without" do
    it "excludes the given users from the relation" do
      bob = create :user, username: "bob"
      alice = create :user, username: "alice"

      expect(User.without([bob]).pluck(:username)).to eq [alice.username]
    end
  end

  describe "#accessable_videos" do
    it "finds public videos" do
      bob = create :user
      video = create :video, private: false, approved: true

      expect(bob.accessable_videos).to eq [video]
    end

    it "excludes private videos" do
      bob = create :user
      video = create :video, private: true, approved: true

      expect(bob.accessable_videos).to eq []
    end

    it "includes private videos shared with the user" do
      bob = create :user
      video = create :video, private: true, approved: true
      Sharing.create!(user: bob, video: video)

      expect(bob.accessable_videos).to eq [video]
    end

    it "doesn't incluce unapproved videos" do
      bob = create :user
      video = create :video, private: false, approved: false

      expect(bob.accessable_videos).to eq []
    end

    it "includes the users own private videos" do
      bob = create :user
      video = create :video, private: true, approved: true, user: bob

      expect(bob.accessable_videos).to eq [video]
    end
  end

  describe "#country_name" do
    it "returns the name of the users country" do
      user = create :user, country_code: "DK"

      expect(user.country_name).to eq "Denmark"
    end
  end

  describe ".authenticate" do
    it "finds users based on username and password" do
      user = create :user, username: "bob", password: "123"

      expect(User.authenticate("bob", "123")).to eq user
    end

    it "finds users based on email and password" do
      user = create :user, email: "bob@example.com", password: "123"

      expect(User.authenticate("bob@example.com", "123")).to eq user
    end

    it "returns nil if the credentials don't match" do
      user = create :user, email: "bob@example.com", password: "123"

      expect(User.authenticate("hest", "123")).to be_nil
      expect(User.authenticate("bob@example.com", "hest")).to be_nil
    end

    it "is case insensitive with username" do
      user = create :user, username: "Bob", password: "123"

      expect(User.authenticate("bob", "123")).to eq user
    end

    it "is case insensitive with email" do
      user = create :user, email: "Bob@example.com", password: "123"

      expect(User.authenticate("bob@example.com", "123")).to eq user
    end

    it "is not case insensitive with password" do
      user = create :user, email: "bob@example.com", password: "hest"

      expect(User.authenticate("bob@example.com", "HEST")).to be_nil
    end
  end
end
