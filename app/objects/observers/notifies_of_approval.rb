# An observer that will notifies a user that their video has been approved
module Observers
  class NotifiesOfApproval
    pattr_initialize [:admin_approving!]

    def save(video)
      Notifier.new(video.user).video_approved(
        video: video,
        admin_approving: admin_approving,
      )
    end

    def save!(video)
      save(video)
    end
  end
end
