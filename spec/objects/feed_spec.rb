require "rails_helper"

describe Feed do
  it "finds move activities" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    bob.follow!(alice)
    move = create :move, name: "Mocking Bird", user: alice
    Activity.create!(user: alice, subject: move)
    Activity.create!(user: create(:user), subject: create(:move))

    items = Feed.new(bob).activities

    expect(items.map(&:name)).to eq [move.name]
  end

  it "sorts stuff by created at" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    bob.follow!(alice)
    move = create :move, name: "Mocking Bird", user: alice

    three = create :move, name: "three", user: alice, created_at: 3.days.ago
    one = create :move, name: "one", user: alice, created_at: 1.days.ago
    two = create :move, name: "two", user: alice, created_at: 2.days.ago

    [three, one, two].each do |move|
      Activity.create!(user: alice, subject: move)
    end

    items = Feed.new(bob).activities

    expect(items.map(&:name)).to eq [one, two, three].map(&:name)
  end

  it "finds approved videos from your followers" do
    bob = create :user
    alice = create :user
    bob.follow!(alice)
    video = create :video, name: "Classic", user: alice, approved: true
    Activity.create!(user: alice, subject: video)

    items = Feed.new(bob).activities

    expect(items.map(&:name)).to eq [video.name]
  end

  it "finds your activities" do
    bob = create :user
    video = create :video, name: "Classic", user: bob, approved: true
    Activity.create!(user: bob, subject: video)

    items = Feed.new(bob).activities

    expect(items.map(&:name)).to eq [video.name]
  end
end
