class Move < ApplicationRecord
  extend DecoratorDelegateMethods

  MINIMUM_NUMBER_OF_RATINGS = 5

  belongs_to :user

  with_options(dependent: :destroy) do |c|
    c.has_many :appearances
    c.has_many :comments, as: :commentable
    c.has_many :ratings, as: :rateable
    c.has_many :credits, as: :creditable
    c.has_many :activities, as: :subject
  end

  validates :name, presence: true, uniqueness: true

  class << self
    def order_by_rating(direction)
      OrdersByRatings.new(self).order(direction)
    end

    def ideas
      where(idea: true)
    end

    def finished
      where(idea: false)
    end
  end

  use WithRatingStats, for: :average_rating

  def thumbnail_url
    nil
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def creditted_users
    User.distinct.joins(:credits).where(credits: { creditable: self })
  end

  def link_text
    name
  end
end
