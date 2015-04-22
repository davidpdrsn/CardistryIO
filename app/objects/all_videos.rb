class AllVideos
  include Enumerable

  def each(&block)
    approved_videos.each(&block)
  end

  def present?
    approved_videos.present?
  end

  private

  def approved_videos
    Video.where(approved: true)
  end
end
