class NotificationType < ActiveRecord::Base
  has_many :notifications, foreign_key: "type_id"

  class << self
    [
      :comment,
      :video_approved,
      :new_follower,
    ].each do |method|
      define_method(method) do
        find_or_create_by!(name: method.to_s)
      end
    end
  end
end
