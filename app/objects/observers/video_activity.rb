# Observer that creates activities for videos when they're being approved
module Observers
  class VideoActivity < SimpleDelegator
    def save(video)
      if video_public?(video)
        __getobj__.save(video)
      end
    end

    private

    def video_public?(video)
      !video.private? && video.approved?
    end
  end
end
