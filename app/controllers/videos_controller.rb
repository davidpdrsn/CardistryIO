class VideosController < ApplicationController
  before_filter :require_login, only: [:index, :new, :create]

  def all_videos
    @videos = AllVideos.new
  end

  def index
    @videos = UserVideos.new(current_user)
  end

  def show
    @video = EmbeddableVideo.new(
      Video.find(params[:id])
    )

    unless @video.approved?
      flash.alert = "Video not yet approved"
      redirect_to root_path
    end
  end

  def new
    @video = Video.new
  end

  def create
    video_params = params.require(:video).permit(:name, :description, :url)
    @video = current_user.videos.new(video_params)
    if @video.save
      flash.notice = "Video created, will appear once it was been approved"
      redirect_to root_path
    else
      flash.alert = "There were errors"
      render :new
    end
  end
end
