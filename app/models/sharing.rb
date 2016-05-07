class Sharing < ApplicationRecord
  belongs_to :video
  belongs_to :user

  validates :video_id, presence: true
  validates :user_id, presence: true
  validate :not_sharing_with_yourself

  def self.videos_shared_with_user(user)
    ids = Sharing.includes(:video).where(user: user).pluck(:video_id)
    Video.where(id: ids)
  end

  def self.video_shared_with_user?(video, user)
    Sharing.where(video: video, user: user).present?
  end

  private

  def not_sharing_with_yourself
    return unless user.present? && user == video.user
    errors.add(:user, "cannot be yourself")
  end
end
