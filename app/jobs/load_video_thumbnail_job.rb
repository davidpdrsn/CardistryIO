class LoadVideoThumbnailJob < ApplicationJob
  def perform(video)
    url = fetch_thumbnail_url(video: video)
    video.update!(thumbnail_url: url)
    unless Rails.env.test?
      cache_image(video: video, url: url)
    end
  rescue JSON::ParserError
  end

  private

  def fetch_thumbnail_url(video:)
    embeddable_video = EmbeddableVideo.new(video)
    embeddable_video.fetch_thumbnail_url
  end

  def cache_image(video:, url:)
    bytes = open_url(url)
    Rails.cache.write(["thumbnail.base64", video], Base64.encode64(bytes))
  end

  def open_url(url)
    uri = URI.parse(url)
    Net::HTTP.get_response(uri).body
  end
end
