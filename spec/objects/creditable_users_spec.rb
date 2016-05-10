require "rails_helper"

describe CreditableUsers do
  it "includes users that can receive credit" do
    alice = create :user, username: "alice"
    bob = create :user, username: "bob"
    move = create :move, user: bob

    users = CreditableUsers.new(current_user: bob, creditable: move).find_users

    expect(users.pluck(:username)).to eq ["alice"]
  end

  context "move" do
    it "doesn't include users who have already been credited" do
      alice = create :user, username: "alice"
      bob = create :user, username: "bob"
      move = create :move, user: bob
      create :credit, user: alice, creditable: move

      users = CreditableUsers.new(current_user: bob, creditable: move)
        .find_users

      expect(users.pluck(:username)).to eq []
    end

    it "doesn't include the user who made the move" do
      alice = create :user, username: "alice"
      bob = create :user, username: "bob"
      move = create :move, user: alice

      users = CreditableUsers.new(current_user: bob, creditable: move)
        .find_users

      expect(users.pluck(:username)).to eq []
    end
  end

  context "video" do
    it "doesn't include users who have already been credited" do
      alice = create :user, username: "alice"
      bob = create :user, username: "bob"
      video = create :video, user: bob
      create :credit, user: alice, creditable: video

      users = CreditableUsers.new(current_user: bob, creditable: video)
        .find_users

      expect(users.pluck(:username)).to eq []
    end

    it "doesn't include the user who made the video" do
      alice = create :user, username: "alice"
      bob = create :user, username: "bob"
      video = create :video, user: alice

      users = CreditableUsers.new(current_user: bob, creditable: video)
        .find_users

      expect(users.pluck(:username)).to eq []
    end
  end
end
