class UserVideos
  def initialize(user)
    @user = user
  end

  include Enumerable

  def each(&block)
    approved_videos.each(&block)
  end

  def present?
    approved_videos.present?
  end

  private

  def approved_videos
    @user.videos.where(approved: true)
  end
end
