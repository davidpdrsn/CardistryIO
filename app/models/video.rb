class Video < ApplicationRecord
  extend DecoratorDelegateMethods

  MINIMUM_NUMBER_OF_RATINGS = 5

  enum video_type: {
    performance: 0,
    tutorial: 1,
    move_showcase: 3,
    jam: 4,
    other: 100,
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
    c.has_many :notifications, as: :subject
    c.has_many :features, as: :featureable
  end

  class << self
    def types_for_filtering(admin: false)
      other_types = video_types.keys.map do |type|
        ["Show only " + type.humanize.pluralize.downcase, type]
      end
      top_filters = [
        ["Show all types", "all"],
      ]
      if admin
        top_filters << ["Show only featured videos", "featured"]
      end
      top_filters + other_types
    end

    def all_public
      approved.where(private: false)
    end

    def approved
      where(approved: true)
    end

    def unapproved
      where(approved: false)
    end

    def all_private
      where(private: true)
    end

    def order_by_rating(direction)
      OrdersByRatings.new(self).order(direction)
    end

    def order_by_views_count(direction)
      direction = sanitize_sort_direction(direction)
      left_outer_joins(:views)
        .group("videos.id")
        .order("COUNT(video_views.id) #{direction}")
    end

    def featured
      joins(<<-SQL)
          LEFT OUTER JOIN features
            ON features.featureable_type = 'Video'
            AND features.featureable_id = videos.id
      SQL
        .group(:id)
        .having("COUNT(features.id) >= 1")
    end

    def not_viewed_by_first(user)
      video_ids = left_outer_joins(:views)
        .order(<<-SQL)
        CASE
          WHEN video_views.user_id = '#{user.id}' THEN 500
          WHEN videos.user_id = '#{user.id}' THEN 1000
          ELSE -1
        END
      SQL
        .pluck(:id)
        .uniq

      Video.find_ordered_by_ids(video_ids)
    end

    def featured_ordered_for(user)
      not_viewed_by_first(user).featured
    end

    private

    def sanitize_sort_direction(direction)
      OrdersByRatings.sanitize_sort_direction(direction)
    end
  end

  use VideoWithUrlHint, for: :url_hint
  use WithRatingStats, for: :average_rating

  def creditted_users
    User.where(id: credits.pluck(:user_id))
  end

  def link_text
    name
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

  def viewed_by(user_viewing)
    return if user == user_viewing
    return if user_viewed_recently?(user_viewing)
    views.create!(user: user_viewing)
  end

  def unique_views_count
    User
      .distinct
      .joins(:video_views)
      .where(video_views: { video: self })
      .count
  end

  def feature!
    Feature.find_or_create_by!(featureable: self)
  end

  def unfeature!
    Feature.where(featureable: self).destroy_all
  end

  def featured?
    Feature.exists?(featureable: self)
  end

  private

  def video_host
    if url.present? && !EmbeddableVideo.host_supported?(url)
      errors.add(:url, "is not supported")
    end
  end

  def user_viewed_recently?(user)
    views_by_user = views.where(user: user)
    return false if views_by_user.empty?
    views_by_user.where(created_at: 1.hour.ago..Time.zone.now).exists?
  end
end
