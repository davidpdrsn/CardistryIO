class EmbeddableVideo < SimpleDelegator
  class Base
    def initialize(video)
      @video = video
    end

    protected

    attr_reader :video
  end

  class VimeoVideo < Base
    def url
      if video.url.match(/player/)
        video.url
      else
        video_id = URI.parse(video.url).path.gsub("/", "")
        "https://player.vimeo.com/video/#{video_id}"
      end
    end

    def fetch_thumbnail_url
      uri = URI.parse("http://vimeo.com/api/v2/video/#{vimeo_id}.json")
      json = JSON.parse(Net::HTTP.get_response(uri).body).first
      json.fetch("user_portrait_huge")
    end

    private

    def vimeo_id
      video.url.match(/vimeo\.com\/(?<id>\d+)/)[:id]
    end
  end

  class YouTubeVideo < Base
    def url
      video.url.sub("watch?v=", "embed/")
    end

    def fetch_thumbnail_url
      "http://img.youtube.com/vi/#{youtube_id}/default.jpg"
    end

    private

    def youtube_id
      video.url.match(/watch\?v=(?<id>[\w_-]*)/)[:id]
    end
  end

  class InstagramVideo < Base
    def url
      video.url
    end

    def fetch_thumbnail_url
      video.thumbnail_url
    end
  end

  class UnsupportedHost < RuntimeError; end

  def self.host_supported?(url)
    CONFIG.keys.any? { |regex| url.match(regex) }
  end

  def initialize(model)
    obj = if model.from_instagram?
            instagram_module = InstagramWrapperFactory.call

            client = instagram_module::Client.unauthenticated_client
            instagram_video = instagram_module::InstagramVideo.new_from_model(model, client)
            DelegationChain.new(model, instagram_video)
          else
            model
          end
    super(obj)
  end

  def class
    __getobj__.class
  end

  def url
    host.url
  end

  def fetch_thumbnail_url
    host.fetch_thumbnail_url
  end

  private

  def host
    host = URI.parse(__getobj__.url).host

    if host.nil?
      raise UnsupportedHost
    end

    CONFIG.each do |regex, klass|
      if host.match(regex)
        return klass.new(__getobj__)
      end
    end

    raise UnsupportedHost
  end

  CONFIG = {
    /vimeo/ => VimeoVideo,
    /youtube/ => YouTubeVideo,
    /instagram/ => InstagramVideo,
  }
end
