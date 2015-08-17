class SharingsController < ApplicationController
  before_action :require_login, only: [:index, :new, :edit, :create, :destroy]

  def index
    @videos = Sharing.videos_shared_with_user(current_user)
  end

  def new
    video = Video.find(params[:video_id])

    if video_owned_by_current_user?(video)
      @users_to_share_with = User.without([current_user])
      @sharing = Sharing.new(video: video)
    else
      flash.alert = "You can't share videos you don't own"
      redirect_to root_path
    end
  end

  def create
    user = User.find(params.require(:sharing).permit(:user)[:user])
    video = current_user.videos.all_private.find(params.require(:video_id))

    previous_share = Sharing.find_by(user_id: user.id, video_id: video.id)
    maybe_create_and_notify(user, video, previous_share)
    flash.notice = "Video shared with #{user.username}"
    redirect_to video
  end

  def edit
    video = current_user.videos.all_private.approved.find(params[:video_id])

    @sharings = Sharing.where(video: video)
  end

  def destroy
    video = current_user.videos.find(params[:video_id])

    Sharing.find(params[:id]).destroy
    redirect_to video
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

  def video_owned_by_current_user?(video)
    video.user == current_user
  end

  def maybe_create_and_notify(user, video, previous_share)
    if previous_share.blank?
      Sharing.create!(user_id: user.id, video_id: video.id)
      Notifier.new(user).video_shared(subject: video, actor: current_user)
    end
  end
end
