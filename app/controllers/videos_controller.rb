class VideosController < ApplicationController
  before_action :require_login, only: [:index, :new,
                                       :create, :destroy,
                                       :edit, :update]

  def all
    videos = Video.all_public.approved
    sort_direction = sort_params.require(:direction)
    videos = if sort_params.require(:by) == "created_at"
               videos.order(created_at: sort_direction)
             else
               videos.order_by_rating(sort_direction)
             end

    @paged_videos = PaginatedRelation.new(
      videos,
      per_page: PaginatedRelation::DEFAULT_PER_PAGE,
    ).page(page)
  end

  def index
    @videos = UserVideos.new(current_user)
  end

  def show
<<<<<<< 0e8e8a0fbdac43bc0fe77a07034102525711ded3
    @video = EmbeddableVideo.new(find_video)
    track_video_view(@video)
=======
    model = if signed_in?
              current_user.accessable_videos.find(params[:id])
            else
              Video.all_public.find(params[:id])
            end

    @video = EmbeddableVideo.new(model)
>>>>>>> Clean up controller

    respond_to do |format|
      format.html {}
      format.json {
        render json: @video, serializer: VideoSerializer, root: false
      }
    end
  end

  def new
    params.delete(:as)
    new_video_params = params.permit(:url, :instagram_id, :description)
    @video = Video.new(new_video_params)
  end

  def create
    @video = current_user.videos.new(strongify(create_params))

    @video.transaction do
      @video.save!
      AddsCredits.new(@video).add_credits(params[:credits])
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

    begin
      @video.transaction do
        @video.update!(strongify(update_params))
        users = AddsCredits.new(@video).update_credits(params[:credits])
        send_notifications(users, @video)
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
    ]
  end

  def send_notifications(users, video)
    users.each do |user|
      Notifier.new(user).new_credit(subject: @video, actor: @video.user)
    end
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
    return if current_user == video.user
    video.viewed_by(current_user)
  end

  def page
    (params[:page] || 1).to_i
  end

  def sort_params
    params.require(:sort).permit(:by, :direction)
  rescue ActionController::ParameterMissing
    default_sort_params
  end

  def default_sort_params
    ActionController::Parameters.new(
      by: "created_at",
      direction: "DESC",
    ).permit!
  end
end
