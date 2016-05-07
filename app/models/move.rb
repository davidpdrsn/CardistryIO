class Move < ApplicationRecord
  extend DecoratorDelegateMethods

  belongs_to :user
  has_many :appearances, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :ratings, as: :rateable
  has_many :credits, as: :creditable

  validates :name, presence: true, uniqueness: true

  use WithRatingStats, for: :average_rating

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def creditted_users
    credits.map(&:user)
  end
end
