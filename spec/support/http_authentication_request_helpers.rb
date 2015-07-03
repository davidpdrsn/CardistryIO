# Helper for authenticating with HTTP basic authentication in request tests
# Defines method `http_login` and `authorized_get`, etc.
module HttpAuthenticationRequestHelpers
  def http_login
    @env ||= {}
    user = "admin"
    pw = "password"
    @env["HTTP_AUTHORIZATION"] =
      ActionController::HttpAuthentication::Basic.encode_credentials(
        Api::AdminController::USERNAME,
        Api::AdminController::PASSWORD
    )
  end

  [:get, :post, :patch, :delete].each do |method|
    define_method("authorized_#{method}") do |path, params = {}|
      send method, path, params, @env
    end
  end
end
