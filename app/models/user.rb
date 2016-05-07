class User < ActiveRecord::Base
  USERNAME_REGEX = /[a-zA-Z0-9_-]+/

  extend DecoratorDelegateMethods
  include Clearance::User
  include Gravtastic

  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :instagram_username, uniqueness: true, allow_nil: true
  validate :format_of_username

  gravtastic

  with_options(dependent: :destroy) do |c|
    c.has_many :moves
    c.has_many :videos
    c.has_many :comments
    c.has_many :ratings
    c.has_many :notifications
    c.has_many :relationships, foreign_key: :follower_id
  end

  use UserWithName, for: :name_for_select

  def can_rate?(rateable)
    UserWithRatingPermissions.new(self).can_rate?(rateable)
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
    return unless relationships.where(followee: user, active: true).blank?
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
    relationships.where(followee: user, active: true).present?
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

  private

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
