class Sharing < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  validates :video_id, presence: true
  validates :user_id, presence: true

  def self.videos_shared_with_user(user)
    ids = Sharing.includes(:video).where(user: user).pluck(:video_id)
    Video.find(ids)
  end

  def self.video_shared_with_user?(video, user)
    Sharing.where(video: video, user: user).present?
  end
end
