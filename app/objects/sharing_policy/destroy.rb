module SharingPolicy
  class Destroy
    def initialize(video:, user:)
      @video = video
      @user = user
    end

    def check_for_violation
      unless video.user == user
        return Violation.new("Can only destroy sharings of your own videos")
      end

      NoViolation.new
    end

    private

    attr_reader :video, :user
  end
end
