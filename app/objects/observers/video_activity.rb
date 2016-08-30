# Observer that only saves decorated video if it is public and approved
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
