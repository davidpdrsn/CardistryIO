class SharingsController < ApplicationController
  before_filter :require_login, only: [:index, :new, :edit, :create, :destroy]

  def index
    @videos = Sharing.videos_shared_with_user(current_user)
  end

  def new
    video = Video.find(params[:video_id])

    if video_owned_by_current_user(video)
      @sharing = Sharing.new(video: video)
    else
      flash.alert = "You can't share videos you don't own"
      redirect_to root_path
    end
  end

  def create
    user = User.find(params.require(:sharing).permit(:user)[:user])
    video = Video.find(params.require(:video_id))

    check_policy(SharingPolicy::Creation, video: video, sharing_user: current_user) do
      Sharing.find_or_create_by!(user_id: user.id, video_id: video.id)

      flash.notice = "Video shared with #{user.username}"
      redirect_to video
    end
  end

  def edit
    video = Video.find(params[:video_id])

    check_policy(SharingPolicy::Edit, video: video, user: current_user) do
      @sharings = Sharing.where(video: video)
    end
  end

  def destroy
    video = Video.find(params[:video_id])

    check_policy(SharingPolicy::Destroy, video: video, user: current_user) do
      Sharing.find(params[:id]).destroy
      redirect_to video
    end
  end

  private

  def check_policy(policy_factory, args)
    policy = policy_factory.new(args)
    violation = policy.check_for_violation

    if violation.policy_violated?
      flash.alert = violation.message
      redirect_to root_path
    else
      yield
    end
  end

  def video_owned_by_current_user(video)
    video.user == current_user
  end
end
