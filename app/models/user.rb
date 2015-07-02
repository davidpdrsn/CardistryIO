class User < ActiveRecord::Base
  extend DecoratorDelegateMethods
  include Clearance::User
  include Gravtastic

  gravtastic

  has_many :moves
  has_many :videos
  has_many :comments

  use UserWithName, for: :name
end
