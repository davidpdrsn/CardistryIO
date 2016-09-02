# Observer that notifies mentioned users when records are being saved
module Observers
  class NotifyMentions
    def save!(subject)
      MentionNotifier.new(subject).notify_mentioned_users
    end

    def save(subject)
      save!(subject)
    end
  end
end
