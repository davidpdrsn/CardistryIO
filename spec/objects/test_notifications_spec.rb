require "rails_helper"

describe TestNotifications do
  it "raises if there are no other users in the database" do
    expect do
      TestNotifications.new(create(:user)).comment_on_video
    end.to raise_error(RuntimeError)
  end

  it "creates comment on video notifications" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    create :video
    notification = TestNotifications.new(bob).comment_on_video

    expect(notification.notification_type).to eq "comment"
    expect(notification.user).to eq bob
    expect(notification.actor).to eq alice
    expect(notification.subject.class).to eq Video
  end

  it "creates comment on move notifications" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    create :move
    notification = TestNotifications.new(bob).comment_on_move

    expect(notification.notification_type).to eq "comment"
    expect(notification.user).to eq bob
    expect(notification.actor).to eq alice
    expect(notification.subject.class).to eq Move
  end

  it "creates video_approved notifications" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    create :video
    notification = TestNotifications.new(bob).video_approved

    expect(notification.notification_type).to eq "video_approved"
    expect(notification.user).to eq bob
    expect(notification.actor).to eq alice
    expect(notification.subject.class).to eq Video
  end

  it "creates new_follower notifications" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    notification = TestNotifications.new(bob).new_follower

    expect(notification.notification_type).to eq "new_follower"
    expect(notification.user).to eq bob
    expect(notification.actor).to eq alice
    expect(notification.subject.class).to eq User
  end

  it "creates video_shared notifications" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    create :video
    notification = TestNotifications.new(bob).video_shared

    expect(notification.notification_type).to eq "video_shared"
    expect(notification.user).to eq bob
    expect(notification.actor).to eq alice
    expect(notification.subject.class).to eq Video
  end

  it "creates mentioned notifications" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    create :video
    notification = TestNotifications.new(bob).mentioned

    expect(notification.notification_type).to eq "mentioned"
    expect(notification.user).to eq bob
    expect(notification.actor).to eq alice
    expect(notification.subject.class).to eq Video
  end

  it "creates new_credit notifications" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    create :video
    notification = TestNotifications.new(bob).new_credit

    expect(notification.notification_type).to eq "new_credit"
    expect(notification.user).to eq bob
    expect(notification.actor).to eq alice
    expect(notification.subject.class).to eq Video
  end
end
