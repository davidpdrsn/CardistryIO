module Admin
  class ApproveVideosController < ApplicationController
    before_action :require_login
    before_action :is_admin?

    def new
      @approved_video = if params[:approved_video_id]
                          Video.find(params[:approved_video_id])
                        end
      @videos = DecoratedCollection.new(Video.unapproved, EmbeddableVideo)
    end

    def create
      video = ApprovingAlsoSaves.new(
        ObservableRecord.new(
          Video.find(params[:id]),
          CompositeObserver.new([
            Observers::HaltUnlessPublic.new(Observers::CreatesActivities.new),
            Observers::NotifiesOfApproval.new(admin_approving: current_user),
            Observers::HaltUnlessPublic.new(Observers::NotifyMentions.new),
            Observers::HaltUnlessPublic.new(Observers::NotifiesCredditedUsers.new),
          ]),
        )
      )

      video.approve!

      redirect_to approve_videos_path(approved_video_id: video.id)
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

  class ApprovingAlsoSaves < ActiveRecordDecorator
    def approve!
      __getobj__.approve!
      __getobj__.save!
    end
  end
end
