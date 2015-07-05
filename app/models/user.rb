class User < ActiveRecord::Base
  extend DecoratorDelegateMethods
  include Clearance::User
  include Gravtastic

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :encrypted_password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :instagram_username, uniqueness: true

  gravtastic

  has_many :moves
  has_many :videos
  has_many :comments

  use UserWithName, for: :name
  use UserWithName, for: :name_for_select

  def to_param
    "#{id}-#{username}"
  end
end
