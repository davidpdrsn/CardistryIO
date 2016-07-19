class InstagramController < ApplicationController
  before_action :require_login, only: [:index, :callback, :create]

  def index
    if instagram_module::Auth.authorized?(session)
      client = instagram_module::Client.authenticated_client(session)
      possibly_add_instagram_username
      @videos = client.videos
    else
      redirect_to instagram_module::Auth.authorize_url(callback_url)
    end
  end

  def callback
    instagram_module::Auth.authenticate(callback_url, session, params)
    redirect_to instagram_path
  end

  around_action :disable_instagram_integration
  def disable_instagram_integration(&block)
    flash.notice = "Instagram integration is coming soon"
    redirect_to root_path
  end

  private

  def possibly_add_instagram_username
    if instagram_module::Auth.authorized?(session) && current_user.instagram_username.nil?
      client = instagram_module::Client.authenticated_client(session)
      current_user.update!(instagram_username: client.user.username)
    end
  end

  def instagram_module
    @_instagram_module ||= InstagramWrapperFactory.call
  end

  def callback_url
    instagram_oauth_callback_url
  end
end
