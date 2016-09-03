class EmbeddableVideo < SimpleDelegator
  def self.host_supported?(url)
    CONFIG.keys.any? { |regex| url.match(regex) }
  end

  def initialize(model, autoplay: false, start: nil)
    @autoplay = autoplay
    @start = start.try(:to_i)
    super(model)
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

  attr_reader :autoplay, :start

  def host
    host = URI.parse(__getobj__.url).host

    if host.nil?
      raise UnsupportedHost
    end

    CONFIG.each do |regex, klass|
      if host.match(regex)
        return klass.new(__getobj__, autoplay: autoplay, start: start)
      end
    end

    raise UnsupportedHost
  end

  class Base
    def initialize(video, autoplay:, start:)
      @video = video
      @autoplay = autoplay
      @start = start
    end

    protected

    attr_reader :video, :autoplay, :start

    def add_query_param(url, key:, value:)
      if url.include?("?")
        "#{url}&#{key}=#{value}"
      else
        "#{url}?#{key}=#{value}"
      end
    end
  end

  class VimeoVideo < Base
    def url
      url = if video.url.match(/player/)
        video.url
      else
        video_id = URI.parse(video.url).path.gsub("/", "")
        "https://player.vimeo.com/video/#{video_id}"
      end

      url = if start
              minutes = start.fdiv(60).floor
              seconds = start % 60
              "#{url}#t=#{minutes}m#{seconds}s"
            else
              url
            end

      url = if autoplay
              add_query_param(url, key: "autoplay", value: "1")
            else
              url
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
      url = video.url.sub("watch?v=", "embed/")

      url = if autoplay
              add_query_param(url, key: "autoplay", value: "1")
            else
              url
            end

      url = if start
              "#{url}?start=#{start}"
              add_query_param(url, key: "start", value: start)
            else
              url
            end

      url
    end

    def fetch_thumbnail_url
      "http://img.youtube.com/vi/#{youtube_id}/hqdefault.jpg"
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

  CONFIG = {
    /vimeo/ => VimeoVideo,
    /youtube/ => YouTubeVideo,
    /instagram/ => InstagramVideo,
  }
end
