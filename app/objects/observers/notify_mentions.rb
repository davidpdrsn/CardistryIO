# Observer that notifies mentioned users when records are being saved
module Observers
  class NotifyMentions
    def save!(move)
      MentionNotifier.new(move).notify_mentioned_users
    end
  end
end
