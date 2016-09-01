module Admin
  class ApproveVideosController < ApplicationController
    before_action :require_login
    before_action :is_admin?

    def new
      @videos = DecoratedCollection.new(Video.unapproved, EmbeddableVideo)
    end

    def create
      video = Video.find(params[:id])
      video.approve!
      Notifier.new(video.user).video_approved(video: video, admin_approving: current_user)
      MentionNotifier.new(video).notify_mentioned_users
      notify_users(video)
      create_activity(video)
      redirect_to approve_videos_path
    end

    def destroy
      Video.find(params[:id]).destroy
      redirect_to approve_videos_path
    end

    private

    def create_activity(video)
      Observers::VideoActivity.new(
        CompositeObserver.new(
          [
            Observers::Activity.new,
          ]
        )
      ).save(video)
    end

    def is_admin?
      unless current_user.admin?
        flash.alert = "Page not found"
        redirect_to root_path
      end
    end

    def notify_users(video)
      video.creditted_users.each do |user|
        Notifier.new(user).new_credit(subject: video, actor: video.user)
      end
    end
  end
end
