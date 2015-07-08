class User < ActiveRecord::Base
  extend DecoratorDelegateMethods
  include Clearance::User
  include Gravtastic

  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :instagram_username, uniqueness: true, allow_nil: true
  validate :format_of_username

  gravtastic

  has_many :moves
  has_many :videos
  has_many :comments
  has_many :ratings
  has_many :notifications
  has_many :relationships, foreign_key: :follower_id

  use UserWithName, for: :name_for_select

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
    relationships.find_or_create_by!(followee: user)
  end

  def follows?(user)
    relationships.where(followee: user).present?
  end

  def following
    User.find(relationships.pluck(:followee_id))
  end

  def followers
    User.find(Relationship.where(followee_id: self.id).pluck(:follower_id))
  end

  def unfollow!(user)
    relationships.find_by!(followee: user).destroy!
  end

  private

  def format_of_username
    if username.present? && !username.match(/^[a-zA-Z0-9_-]+$/)
      errors.add(
        :username,
        "can only contain letters, numbers, dashes, and underscores"
      )
    end
  end
end
