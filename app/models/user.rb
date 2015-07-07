class User < ActiveRecord::Base
  extend DecoratorDelegateMethods
  include Clearance::User
  include Gravtastic

  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :instagram_username, uniqueness: true

  gravtastic

  has_many :moves
  has_many :videos
  has_many :comments
  has_many :ratings
  has_many :notifications

  use UserWithName, for: :name_for_select

  def to_param
    "#{id}-#{username}"
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
end
