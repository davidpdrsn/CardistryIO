# An observer that notifies creddited users that they have received credit
module Observers
  class NotifiesCredditedUsers
    def save(video)
      video.creditted_users.each do |user|
        Notifier.new(user).new_credit(subject: video, actor: video.user)
      end
    end

    def save!(video)
      save(video)
    end
  end
end
