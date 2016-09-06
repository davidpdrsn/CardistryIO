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

  context "moves as subjects" do
    it "updates when the move changes" do
      move = create :move
      activity = create :activity, subject: move, updated_at: 2.weeks.ago

      expect do
        move.update(name: "#{move.name}-1")
      end.to change { activity.reload.updated_at }
    end
  end

  context "videos as subjects" do
    it "updates when the video changes" do
      video = create :video
      activity = create :activity, subject: video, updated_at: 2.weeks.ago

      expect do
        video.update(name: "#{video.name}-1")
      end.to change { activity.reload.updated_at }
    end
  end
end
