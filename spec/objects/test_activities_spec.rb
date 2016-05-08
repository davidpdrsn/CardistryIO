require "rails_helper"

describe TestActivities do
  it "doesn't work in production env" do
    SwapsEnv.new.swap_for("production") do
      user = create :user

      expect do
        TestActivities.new(user).video
      end.to raise_error(RuntimeError)
    end
  end

  it "requires at least one video to be present" do
    user = create :user

    expect do
      TestActivities.new(user).video
    end.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "creates activities for videos" do
    user = create :user
    video = create :video

    activity = TestActivities.new(user).video

    expect(user.activities).to eq [activity]
    expect(activity.subject).to eq video
  end

  it "creates activities for moves" do
    user = create :user
    move = create :move

    activity = TestActivities.new(user).move

    expect(user.activities).to eq [activity]
    expect(activity.subject).to eq move
  end
end
