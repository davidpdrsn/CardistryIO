module Api
  class AdminController < Api::Controller
    before_action :require_authentication

    USERNAME = ENV.fetch("ADMIN_USERNAME")
    PASSWORD = ENV.fetch("ADMIN_PASSWORD")

    private

    def require_authentication
      authenticate_or_request_with_http_basic do |username, password|
        username == USERNAME && password == PASSWORD
      end
    end
  end
end
