class Move < ApplicationRecord
  extend DecoratorDelegateMethods

  belongs_to :user

  with_options(dependent: :destroy) do |c|
    c.has_many :appearances
    c.has_many :comments, as: :commentable
    c.has_many :ratings, as: :rateable
    c.has_many :credits, as: :creditable
    c.has_many :activities, as: :subject
  end

  validates :name, presence: true, uniqueness: true

  use WithRatingStats, for: :average_rating

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def creditted_users
    credits.map(&:user)
  end
end
