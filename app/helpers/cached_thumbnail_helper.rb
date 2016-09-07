module CachedThumbnailHelper
  def cached_thumbnail_image(video)
    Helper.new(video: video, view_context: self).cached_thumbnail_image
  end

  class Helper
    def initialize(video:, view_context:)
      @video = video
      @view_context = view_context
    end

    def cached_thumbnail_image
      view_context.content_tag(
        :div,
        nil,
        class: "thumbnail",
        style: style,
      )
    end

    private

    attr_reader :video, :view_context

    def style
      data = if cached_thumbnail_exists?
               "data:image/png;base64,#{base64_image.split("\n").join}"
             else
               if Rails.env.production? || Rails.env.staging?
                 LoadVideoThumbnailJob.perform_later(video)
               end
               video.thumbnail_url
             end

      "background: url(#{data}) no-repeat center; background-size: cover;"
    end

    def cached_thumbnail_exists?
      !base64_image.nil?
    end

    def base64_image
      @base64_image ||= Rails.cache.read(["thumbnail.base64", video])
    end
  end
end
