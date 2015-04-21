class VideoAppearancesController < ApplicationController
  before_filter :require_login
  before_filter :has_access, only: [:edit, :update]

  def edit
    @video = Video.find(params[:id])
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
