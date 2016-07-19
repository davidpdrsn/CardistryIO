require "rails_helper"

describe LoadVideoThumbnailJob do
  include ActiveJob::TestHelper

  it "loads the thumbnail for videos" do
    video = create :video

    perform_enqueued_jobs do
      LoadVideoThumbnailJob.perform_later(video)
    end

    expect(video.reload.thumbnail_url).to_not be_nil
  end
end
