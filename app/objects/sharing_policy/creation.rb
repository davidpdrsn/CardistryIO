# TODO: Unit test this, convert SharingsController tests to use mocks
module SharingPolicy
  class Creation
    def initialize(video:, sharing_user:)
      @video = video
      @user = sharing_user
    end

    def check_for_violation
      unless video_owned_by_user
        return Violation.new("Can only share videos you own")
      end

      if video_is_public
        return Violation.new("Cannot share public videos")
      end

      NoViolation.new
    end

    private

    attr_reader :video, :user

    def video_owned_by_user
      video.user == user
    end

    def video_is_public
      video.private == false
    end
  end
end
