# TODO: Unit test this, convert SharingsController tests to use mocks
module SharingPolicy
  class Viewing
    def initialize(video:, viewing_user:)
      @video = video
      @user = viewing_user
    end

    def check_for_violation
      unless video.approved?
        return Violation.new("Video not yet approved")
      end

      if user_doesnt_have_access_to_video
        return Violation.new("This video is private")
      end

      return NoViolation.new
    end

    private

    attr_reader :video, :user

    def user_doesnt_have_access_to_video
      video.private && user_doesnt_own_video && not_shared_with_user
    end

    def not_shared_with_user
      !Sharing.video_shared_with_user?(video, user)
    end

    def user_doesnt_own_video
      video.user != user
    end
  end
end
