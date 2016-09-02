require "rails_helper"

describe Observers::HaltUnlessPublic do
  it "creates activities for the video" do
    observer = double(:observer)
    allow(observer).to receive(:save!)
    video = double(:video, private: false, approved?: true)
    video_observer = Observers::HaltUnlessPublic.new(observer)

    video_observer.save(video)

    expect(observer).to have_received(:save!)
  end

  it "doesn't create activities if the video is private" do
    observer = double(:observer)
    allow(observer).to receive(:save!)
    video = double(:video, private: true, approved?: true)
    video_observer = Observers::HaltUnlessPublic.new(observer)

    video_observer.save(video)

    expect(observer).not_to have_received(:save!)
  end
end
