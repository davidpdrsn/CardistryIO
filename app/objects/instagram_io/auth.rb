module InstagramIO
  class Auth
    class << self
      def authorized?(session)
        session[:instagram_access_token].present?
      end

      def authorize_url
        Instagram.authorize_url(redirect_uri: callback_url)
      end

      def authenticate(session, params)
        response = Instagram.get_access_token(
          params.fetch(:code),
          redirect_uri: callback_url
        )
        session[:instagram_access_token] = response.access_token
      end

      private

      def callback_url
        instagram_oauth_callback_url
      end
    end
  end
end
