# Observer decorator that only delegates to composed observer when video
# is public
module Observers
  class HaltUnlessPublic < SimpleDelegator
    def save!(video)
      return unless !video.private
      __getobj__.save!(video)
    end

    def save(video)
      save!(video)
      true
    rescue ActiveRecord::ActiveRecordError
      false
    end

    def update!(video, params)
      return unless !video.private
      __getobj__.update!(video, params)
    end

    def update(video, params)
      update!(video, params)
      true
    rescue ActiveRecord::ActiveRecordError
      false
    end
  end
end
