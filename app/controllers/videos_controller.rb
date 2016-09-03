class VideosController < ApplicationController
  before_action :require_login, only: [:index, :new,
                                       :create, :destroy,
                                       :edit, :update]

  def all
    @filter_submit_path = all_videos_path
    @paged_videos = filter_sort_and_paginate(Video.all_public.approved)
    title t("titles.videos.all")
  end

  def index
    @filter_submit_path = videos_path
    @paged_videos = filter_sort_and_paginate(current_user.videos.approved)
    title t("titles.videos.index")
  end

  def show
    start = if params[:start].to_i.to_s == params[:start]
              params[:start]
            else
              nil
            end
    @video = EmbeddableVideo.new(
      find_video,
      autoplay: params[:autoplay] == "true",
      start: start,
    )
    track_video_view(@video)

    respond_to do |format|
      format.html {
        title @video.name
      }
      format.json {
        render json: @video, serializer: VideoSerializer, root: false
      }
    end
  end

  def new
    params.delete(:as)
    new_video_params = params.permit(
      :url,
      :instagram_id,
      :description,
      :thumbnail_url,
    )
    @video = Video.new(new_video_params)
    title t("titles.videos.new")
  end

  def create
    @video = current_user.videos.new(strongify(create_params))

    @video.transaction do
      @video.save!
      AddsCredits.new(@video).add_credits(params[:credits])
      LoadVideoThumbnailJob.perform_later(@video)
      flash.notice = "Video created, will appear once it was been approved"
      redirect_to root_path
    end
  rescue ActiveRecord::ActiveRecordError
    flash.alert = "There were errors"
    render :new
  end

  def edit
    @video = current_user.videos.find(params[:id])
    title t("titles.videos.edit")
  end

  def update
    @video = ObservableRecord.new(
      current_user.videos.find(params[:id]),
      Observers::HaltUnlessPublic.new(
        Observers::AddsCreditAndNotifies.new(params, current_user),
      ),
    )

    begin
      @video.transaction do
        private_before = @video.private
        @video.update!(strongify(update_params))
        private_after = @video.private

        if private_after
          @video.activities.each(&:destroy!)
        end

        if private_before && !private_after
          Observers::CreatesActivities.new.save!(@video)
        end

        flash.notice = "Video updated"
        redirect_to @video
      end
    rescue ActiveRecord::ActiveRecordError
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

  def strongify(permitted)
    params.require(:video).permit(*permitted)
  end

  def create_params
    update_params + [:url]
  end

  def update_params
    [
      :name,
      :description,
      :private,
      :instagram_id,
      :video_type,
      :thumbnail_url,
    ]
  end

  def find_video
    if signed_in?
      current_user.accessable_videos.find(params[:id])
    else
      Video.all_public.find(params[:id])
    end
  end

  def track_video_view(video)
    return unless signed_in?
    video.viewed_by(current_user)
  end

  def filter_sort_and_paginate(videos)
    ListTransformer.new(
      relation: videos,
      params: params,
      filter_with: FiltersVideos,
      sort_with: SortsVideos,
    ).transform
  end
end
