module Admin
  class ApproveVideosController < ApplicationController
    before_filter :require_login
    before_filter :is_admin?

    def new
      @videos = DecoratedCollection.new(Video.unapproved, EmbeddableVideo)
    end

    def create
      video = Video.find(params[:id])
      video.approve!
      Notifier.new(video.user).video_approved(subject: video, actor: current_user)
      MentionNotifier.new(video).check_for_mentions
      redirect_to approve_videos_path
    end

    def destroy
      Video.find(params[:id]).destroy
      redirect_to approve_videos_path
    end

    private

    def is_admin?
      unless current_user.admin?
        flash.alert = "Page not found"
        redirect_to root_path
      end
    end
  end
end
