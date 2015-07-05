class InstagramController < ApplicationController
  def index
    if InstagramIO::Auth.authorized?(session)
      client = InstagramIO::Client.new(session)
      render json: client.user_recent_media.as_json
    else
      redirect_to InstagramIO::Auth.authorize_url
    end
  end

  def callback
    InstagramIO::Auth.authenticate(session, params)
    redirect_to instagram_path
  end
end
