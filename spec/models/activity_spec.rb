require "rails_helper"

describe Activity do
  it { should belong_to :user }
  it { should belong_to :subject }

  it { should validate_presence_of :subject }
  it { should validate_presence_of :user }

  describe "validations" do
    it "is valid for moves" do
      user = create :user
      move = create :move
      activity = Activity.new(subject: move, user: user)

      expect(activity).to be_valid
    end

    it "is valid for videos" do
      user = create :user
      video = create :video
      activity = Activity.new(subject: video, user: user)

      expect(activity).to be_valid
    end

    it "is invalid for unknown types" do
      user = create :user
      activity = Activity.new(subject: user, user: user)

      expect(activity).to_not be_valid
    end
  end
end
