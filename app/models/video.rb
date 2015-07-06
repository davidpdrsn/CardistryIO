class Video < ActiveRecord::Base
  extend DecoratorDelegateMethods

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true
  validate :video_host

  belongs_to :user
  has_many :appearances, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :ratings, as: :rateable
  has_many :sharings

  scope :all_public, -> { approved.where(private: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  use VideoWithUrlHint, for: :url_hint
  use WithRatingStats, for: :average_rating

  def approve!
    update!(approved: true)
  end

  def from_instagram?
    url.include?("instagram")
  end

  private

  def video_host
    if url.present? && !EmbeddableVideo.host_supported?(url)
      errors.add(:url, "is not supported")
    end
  end
end
