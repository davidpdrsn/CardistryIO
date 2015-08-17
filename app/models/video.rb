class Video < ApplicationRecord
  extend DecoratorDelegateMethods

  enum video_type: [
    :performance,
    :tutorial,
    :idea,
    :move_showcase,
    :other,
  ]

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true
  validates :video_type, presence: true
  validate :video_host

  belongs_to :user
  has_many :appearances, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :ratings, as: :rateable
  has_many :credits, as: :creditable
  has_many :sharings

  scope :all_public, -> { approved.where(private: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  scope :all_private, -> { where(private: true) }

  use VideoWithUrlHint, for: :url_hint
  use WithRatingStats, for: :average_rating

  def creditted_users
    User.where(id: credits.pluck(:user_id))
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

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
