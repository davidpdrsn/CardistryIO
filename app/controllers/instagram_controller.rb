class InstagramController < ApplicationController
  before_filter :require_login, only: [:index, :callback, :create]

  def index
    if InstagramIO::Auth.authorized?(session)
      client = InstagramIO::Client.new(session)
      @videos = client.videos
    else
      redirect_to InstagramIO::Auth.authorize_url(callback_url)
    end
  end

  def callback
    InstagramIO::Auth.authenticate(callback_url, session, params)
    redirect_to instagram_path
  end

  private

  def callback_url
    instagram_oauth_callback_url
  end
end
