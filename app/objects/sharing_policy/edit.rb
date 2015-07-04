module SharingPolicy
  class Edit
    def initialize(video:, user:)
      @video = video
      @user = user
    end

    def check_for_violation
      unless video.user == user
        return Violation.new("Can only edit sharings of your own videos")
      end

      unless video.private
        return Violation.new("Can only edit sharings of private videos")
      end

      unless video.approved
        return Violation.new("Video most be approved")
      end

      NoViolation.new
    end

    private

    attr_reader :video, :user
  end
end
