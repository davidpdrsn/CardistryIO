class FeaturedVideosController < ApplicationController
  before_action :require_login, only: [:create, :destroy]
  around_action :require_admin, only: [:create, :destroy]

  def index
    @videos = Video.featured
  end

  def create
    video = Video.find(params[:id])
    video.feature!
    Notifier.new(video.user).video_featured(video: video, admin_featuring: current_user)
    redirect_to video
  end

  def destroy
    video = Video.find(params[:id])
    video.unfeature!
    redirect_to video
  end

  private

  def require_admin
    if current_user.admin
      yield
    else
      flash.alert = "Only admins are allowed to feature videos"
      redirect_to root_path
    end
  end
end
