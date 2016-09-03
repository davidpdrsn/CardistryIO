module InstagramIO
  class Auth
    class << self
      def authorized?(session)
        session[:instagram_access_token].present?
      end

      def authorize_url(callback_url)
        Instagram.authorize_url(redirect_uri: callback_url, scopes: "basic public_content")
      end

      def authenticate(callback_url, session, params)
        response = Instagram.get_access_token(
          params.fetch(:code),
          redirect_uri: callback_url
        )
        session[:instagram_access_token] = response.access_token
      end
    end
  end
end
