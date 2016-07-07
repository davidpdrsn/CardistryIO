class LoadVideoThumbnailJob < ApplicationJob
  def perform(video)
    embeddable_video = EmbeddableVideo.new(video)
    video.update!(thumbnail_url: embeddable_video.fetch_thumbnail_url)
  end
end
