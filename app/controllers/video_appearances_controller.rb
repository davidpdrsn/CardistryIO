class VideoAppearancesController < ApplicationController
  before_action :require_login
  before_action :has_access, only: [:edit, :update, :destroy]

  def edit
    @video = EmbeddableVideo.new(
      Video.find(params[:id])
    )
  end

  def update
    video_appearances = VideoAppearances.new(
      video:      video,
      move_names: params[:move_names],
      minutes:    params[:minutes].map(&:to_i),
      seconds:    params[:seconds].map(&:to_i),
    )

    if video_appearances.save
      flash.notice = "Saved"
      redirect_to video
    else
      flash.alert = "Error"
      render :edit
    end
  end

  def destroy
    video = Video.find(params[:id])
    video.appearances.destroy_all
    flash.notice = "Deleted"
    redirect_to video
  end

  private

  def has_access
    if current_user.id != video.user_id
      flash.alert = "Page not found"
      redirect_to root_path
    end
  end

  def video
    @video ||= Video.find(params[:id])
  end
end
