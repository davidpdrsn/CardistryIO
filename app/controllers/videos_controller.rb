class VideosController < ApplicationController
  before_filter :require_login, only: [:index, :new, :create]

  def all_videos
    @videos = Video.all
  end

  def index
    @videos = current_user.videos
  end

  def show
    @video = EmbeddableVideo.new(
      Video.find(params[:id])
    )
  end

  def new
    @video = Video.new
  end

  def create
    video_params = params.require(:video).permit(:name, :description, :url)
    @video = current_user.videos.new(video_params)
    if @video.save
      flash.notice = "Video created"
      redirect_to @video
    else
      flash.alert = "There were errors"
      render :new
    end
  end
end
