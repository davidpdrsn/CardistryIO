class VideosController < ApplicationController
  before_filter :require_login, only: [:index, :new, :create, :destroy, :edit, :update]

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
    @video = current_user.videos.new(video_params)
    if @video.save
      flash.notice = "Video created, will appear once it was been approved"
      redirect_to root_path
    else
      flash.alert = "There were errors"
      render :new
    end
  end

  def edit
    @video = current_user.videos.find(params[:id])
  end

  def update
    @video = current_user.videos.find(params[:id])

    if @video.update(video_params)
      flash.notice = "Video updated"
      redirect_to @video
    else
      flash.alert = "There were errors"
      render :new
    end
  end

  def destroy
    video = Video.find(params[:id])

    if current_user == video.user
      video.destroy
      flash.notice = "Video deleted"
    else
      flash.alert = "Can only delete your own videos"
    end

    redirect_to root_path
  end

  private

  def video_params
    params.require(:video).permit(:name, :description, :url)
  end
end
