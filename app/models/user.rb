class User < ActiveRecord::Base
  extend DecoratorDelegateMethods
  include Clearance::User
  include Gravtastic

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :encrypted_password, presence: true

  gravtastic

  has_many :moves
  has_many :videos
  has_many :comments

  use UserWithName, for: :name

  def to_param
    "#{id}-#{first_name}-#{last_name}"
  end
end
