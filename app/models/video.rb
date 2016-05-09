class Video < ApplicationRecord
  extend DecoratorDelegateMethods

  enum video_type: {
    performance: 0,
    tutorial: 1,
    idea: 2,
    move_showcase: 3,
    other: 4,
  }

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true
  validates :video_type, presence: true
  validate :video_host

  belongs_to :user

  with_options(dependent: :destroy) do |c|
    c.has_many :activities, as: :subject
    c.has_many :appearances
    c.has_many :comments, as: :commentable
    c.has_many :credits, as: :creditable
    c.has_many :ratings, as: :rateable
    c.has_many :sharings
    c.has_many :views, class_name: "VideoView"
  end

  scope :all_public, -> { approved.where(private: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }
  scope :all_private, -> { where(private: true) }

  use VideoWithUrlHint, for: :url_hint
  use WithRatingStats, for: :average_rating

  def self.order_by_rating(direction)
    direction = direction.to_s.upcase

    direction = if direction == "ASC"
                  direction
                else
                  "DESC"
                end

    joins(:ratings)
      .group("videos.id")
      .order("SUM(ratings.rating) #{direction}")
  end

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

  def viewed_by(user)
    views.create!(user: user)
  end

  def unique_views_count
    User.distinct.joins(:video_views).count
  end

  private

  def video_host
    if url.present? && !EmbeddableVideo.host_supported?(url)
      errors.add(:url, "is not supported")
    end
  end
end
