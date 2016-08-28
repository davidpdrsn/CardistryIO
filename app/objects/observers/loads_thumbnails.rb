# An observer that will load thumbnails for videos when they get saved
module Observers
  class LoadsThumbnails
    def save(video)
      save!(video)
      true
    rescue
      false
    end

    def save!(video)
      LoadVideoThumbnailJob.perform_now(video)
    end
  end
end
