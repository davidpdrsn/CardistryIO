require "rails_helper"

describe AddsCredits do
  describe "#add_credits" do
    it "adds credits to the model" do
      video = create :video
      bob = create :user, username: "bob"

      AddsCredits.new(video).add_credits([bob.username])

      expect(video.creditted_users.map(&:username)).to eq [bob.username]
    end

    it "does nothing if there are no params" do
      video = create :video

      AddsCredits.new(video).add_credits([])

      expect(video.creditted_users.map(&:username)).to eq []
    end

    it "does nothing if params are nil" do
      video = create :video

      AddsCredits.new(video).add_credits(nil)

      expect(video.creditted_users.map(&:username)).to eq []
    end
  end

  describe "#update_credits" do
    it "updates the credits" do
      video = create :video
      bob = create :user, username: "bob"
      alice = create :user, username: "alice"

      AddsCredits.new(video).add_credits([bob.username])
      AddsCredits.new(video).update_credits([alice.username])

      expect(video.creditted_users.map(&:username)).to eq [alice.username]
    end

    it "does nothing if there are no usernames" do
      video = create :video
      bob = create :user, username: "bob"

      AddsCredits.new(video).add_credits([bob.username])
      AddsCredits.new(video).update_credits([])

      expect(video.creditted_users.map(&:username)).to eq [bob.username]
    end

    it "does nothing if usernames are nil" do
      video = create :video
      bob = create :user, username: "bob"

      AddsCredits.new(video).add_credits([bob.username])
      AddsCredits.new(video).update_credits(nil)

      expect(video.creditted_users.map(&:username)).to eq [bob.username]
    end
  end
end
