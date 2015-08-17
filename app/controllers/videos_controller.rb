class VideosController < ApplicationController
  before_action :require_login, only: [:index, :new,
                                       :create, :destroy,
                                       :edit, :update]

  def all
    @videos = AllVideos.new
  end

  def index
    @videos = UserVideos.new(current_user)
  end

  def show
    # Return NullRelation from NullUser#videos to avoid conditional
    model = if signed_in?
              current_user.accessable_videos.find(params[:id])
            else
              Video.all_public.find(params[:id])
            end

    @video = EmbeddableVideo.new(model)

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
end
