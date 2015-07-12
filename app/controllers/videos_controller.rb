class VideosController < ApplicationController
  before_filter :require_login, only: [:index, :new,
                                       :create, :destroy,
                                       :edit, :update]

  def all
    @videos = AllVideos.new
  end

  def index
    @videos = UserVideos.new(current_user)
  end

  def show
    model = Video.find(params[:id])

    @video = EmbeddableVideo.new(model)

    policy = SharingPolicy::Viewing.new(
      video: @video,
      viewing_user: current_user
    )
    violation = policy.check_for_violation

    if violation.policy_violated?
      flash.alert = violation.message
      redirect_to root_path
    end
  end

  def new
    params.delete(:as)
    new_video_params = params.permit(:url, :instagram_id, :description)
    @video = Video.new(new_video_params)
  end

  def create
    @video = current_user.videos.new(video_params)

    ActiveRecord::Base.transaction do
      AddsCredits.new(@video).add_credits(params[:credits])
      @video.save!
      flash.notice = "Video created, will appear once it was been approved"
      redirect_to root_path
    end
  rescue ActiveRecord::ActiveRecordError
    flash.alert = "There were errors"
    render :new
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
    params.require(:video).permit(
      :name,
      :description,
      :url,
      :private,
      :instagram_id,
      :video_type,
    )
  end
end
