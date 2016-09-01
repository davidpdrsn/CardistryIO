class User < ApplicationRecord
  USERNAME_REGEX = /[a-zA-Z0-9_-]+/
  BIOGRAPHY_MAX_LENGTH = 100

  extend DecoratorDelegateMethods
  include Clearance::User
  include Gravtastic

  enum email_frequency: {
    immediately: 0,
    never: 100,
  }

  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :instagram_username, uniqueness: true, allow_nil: true
  validates :country_code, presence: true
  validates(
    :time_zone,
    inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) },
    presence: true,
  )
  validates(
    :country_code,
    inclusion: { in: ISO3166::Country.all.map(&:alpha2) },
    presence: true,
  )
  validates :biography, length: { maximum: BIOGRAPHY_MAX_LENGTH }
  validate :format_of_username

  gravtastic

  with_options(dependent: :destroy) do |c|
    c.has_many :activities
    c.has_many :comments
    c.has_many :moves
    c.has_many :notifications
    c.has_many :ratings
    c.has_many :relationships, foreign_key: :follower_id
    c.has_many :video_views
    c.has_many :videos
    c.has_many :credits
  end

  use UserWithName, for: :name_for_select

  def self.authenticate(username_or_email, password)
    user = where("lower(username) = lower(?)", username_or_email)
      .or(where(email: username_or_email))
      .first

    return nil unless user
    return user if user.authenticated?(password)
  end

  def email_optional?
    true
  end

  def can_rate?(rateable)
    UserWithRatingPermissions.new(self).can_rate?(rateable)
  end

  def link_text
    "@#{username}"
  end

  def self.without(users)
    where.not(id: users.map(&:id))
  end

  def to_param
    "#{id}-#{username.parameterize}"
  end

  def already_rated?(rateable, type:)
    ratings.where(
      rateable_id: rateable.id,
      rateable_type: type.to_s.titleize,
    ).present?
  end

  def new_notifications
    notifications.where(seen: false)
  end

  def follow!(user)
    if follows?(user)
      return OldRelationship.new(current_relationship_with(user))
    end

    klass = if relationships.where(followee: user, active: false).present?
              OldRelationship
            else
              NewRelationship
            end

    relationship = relationships.find_or_create_by!(followee: user)
    relationship.make_active!
    klass.new(relationship)
  end

  def follows?(user)
    current_relationship_with(user).present?
  end

  def following
    ids = relationships.where(active: true).pluck(:followee_id)
    User.where(id: ids)
  end

  def followers
    ids = Relationship
      .where(followee_id: self.id, active: true)
      .pluck(:follower_id)
    User.where(id: ids)
  end

  def unfollow!(user)
    relationships.find_by!(followee: user).make_inactive!
  end

  def accessable_videos
    own_videos = videos.pluck(:id)
    public_videos = Video.all_public.pluck(:id)
    shared_videos = Video.where(id: Sharing.where(user: self).pluck(:video_id)).pluck(:id)
    Video.where(id: public_videos | shared_videos | own_videos)
  end

  def country_name
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  private

  def current_relationship_with(user)
    relationships.where(followee: user, active: true)
  end

  def format_of_username
    if username.present? && !username.match(/^#{USERNAME_REGEX}$/)
      errors.add(
        :username,
        "can only contain letters, numbers, dashes, and underscores"
      )
    end
  end

  class RelationshipsWithAge < SimpleDelegator
    class << self
      def method_missing(name, *args, &block)
        Relationship.send(name, *args, &block)
      end
    end
  end

  class NewRelationship < RelationshipsWithAge
    def new?
      true
    end
  end

  class OldRelationship < RelationshipsWithAge
    def new?
      false
    end
  end
end
