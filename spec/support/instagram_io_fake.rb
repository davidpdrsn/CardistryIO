module InstagramIOFake
  class Auth
    def self.authorized?(*)
      true
    end
  end

  class Client
    def self.authenticated_client(*)
      new
    end

    def user
      InstagramIOFake::InstagramUser.new
    end

    def videos
      [
        InstagramIOFake::InstagramVideo.new(
          caption: "Classic"
        )
      ]
    end
  end

  class InstagramVideo
    def self.new_from_model(video_model, client)
      new(caption: "Classic")
    end

    def initialize(options)
      @options = options
    end

    def from_instagram?
      true
    end

    def thumbnail_url
      ""
    end

    def image
      ""
    end

    def url
      "https://scontent.cdninstagram.com/hphotos-xaf1/t50.2886-16/11243245_1599951966956675_1378908578_s.mp4"
    end

    def instagram_id
      1337
    end

    def method_missing(name, *args, &block)
      options.fetch(name) { raise NoMethodError.new("#{name} for #{self}") }
    end

    def respond_to_missing?(name, include_private = false)
      options[name].present?
    end

    private

    attr_reader :options
  end

  class InstagramUser
    def username
      "kevho"
    end
  end
end
