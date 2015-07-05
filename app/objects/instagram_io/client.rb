module InstagramIO
  class Client
    def self.authenticated_client(session)
      AuthenticatedClient.new(
        access_token: session.fetch(:instagram_access_token)
      )
    end

    def self.unauthenticated_client
      UnauthenticatedClient.new(
        client_id: ENV.fetch("INSTAGRAM_CLIENT_ID")
      )
    end

    private

    class UnauthenticatedClient
      def initialize(args)
        @client = Instagram.client(args)
      end

      def find(id)
        client.media_item(id)
      end

      private

      attr_reader :client
    end

    class AuthenticatedClient < UnauthenticatedClient
      def videos
        client.user_recent_media.reduce([]) do |acc, media|
          if is_video?(media) && !exists_already?(media)
            acc + [InstagramVideo.new(media)]
          else
            acc
          end
        end
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
