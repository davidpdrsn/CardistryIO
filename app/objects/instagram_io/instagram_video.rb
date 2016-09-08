module InstagramIO
  class InstagramVideo
    def self.new_from_model(video_model, client)
      if video_model.instagram_id.blank?
        raise ArgumentError.new("Cannot create InstagramIO::InstagramVideo from model without instagram_id")
      end

      instagram_video = client.find(video_model.instagram_id)
      new(instagram_video)
    end

    def initialize(video)
      @video = video
    end

    def instagram_id
      video.id
    end

    def from_instagram?
      true
    end

    def url
      video.videos.send(resolution).url
    end

    def caption
      video.caption.text
    end

    def image
      video.images.send(resolution).url
    end

    def thumbnail_url
      image
    end

    def height
      video.videos.send(resolution).height
    end

    def width
      video.videos.send(resolution).width
    end

    private

    def resolution
      :low_resolution
    end

    attr_reader :video
  end
end
