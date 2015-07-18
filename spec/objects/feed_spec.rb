require "rails_helper"

describe Feed do
  it "finds new moves from your followers" do
    bob = create :user
    alice = create :user
    bob.follow!(alice)
    move = create :move, name: "Classic", user: alice
    create :move

    items = Feed.new(bob).stories

    expect(items.map(&:name)).to eq [move.name]
  end

  it "sorts stuff by created at" do
    bob = create :user
    alice = create :user
    bob.follow!(alice)
    three = create :move, name: "three", user: alice, created_at: 3.days.ago
    one = create :move, name: "one", user: alice, created_at: 1.days.ago
    two = create :move, name: "two", user: alice, created_at: 2.days.ago

    items = Feed.new(bob).stories

    expect(items.map(&:name)).to eq [one, two, three].map(&:name)
  end

  it "finds approved videos from your followers" do
    bob = create :user
    alice = create :user
    bob.follow!(alice)
    video = create :video, name: "Classic", user: alice, approved: true
    create :video

    items = Feed.new(bob).stories

    expect(items.map(&:name)).to eq [video.name]
  end

  it "doesn't include videos that are not approved" do
    bob = create :user
    alice = create :user
    bob.follow!(alice)
    create :video, name: "Classic", user: alice, approved: false

    items = Feed.new(bob).stories

    expect(items.map(&:name)).to eq []
  end

  it "doesn't include private videos" do
    bob = create :user
    alice = create :user
    bob.follow!(alice)
    create :video, name: "Classic", user: alice, approved: true, private: true

    items = Feed.new(bob).stories

    expect(items.map(&:name)).to eq []
  end

  it "includes videos shared with you" do
    bob = create :user
    alice = create :user
    bob.follow!(alice)
    video = create(:video,
                   name: "Classic",
                   user: alice,
                   approved: true,
                   private: true)
    create :sharing, video: video, user: bob

    items = Feed.new(bob).stories

    expect(items.map(&:name)).to eq [video.name]
  end
end
