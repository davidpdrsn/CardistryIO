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

      def user_recent_media
        @client.user_recent_media
      end

      private

      attr_reader :client
    end
  end
end
