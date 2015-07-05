module InstagramIO
  class Client
    def self.new(session)
      token = session.fetch(:instagram_access_token)
      Wrapped.new(
        Instagram.client(access_token: token)
      )
    end

    private

    class Wrapped
      def initialize(client)
        @client = client
      end

      def videos
        @client.user_recent_media.reduce([]) do |acc, media|
          if is_video?(media) && !exists_already?(media)
            acc + [InstagramVideo.new(media)]
          else
            acc
          end
        end
      end

      def find(id)
        client.media_item(id)
      end

      private

      def exists_already?(media)
        ::Video.where(instagram_id: media.id).present?
      end

      def is_video?(media)
        media.type == "video"
      end

      attr_reader :client
    end
  end
end
