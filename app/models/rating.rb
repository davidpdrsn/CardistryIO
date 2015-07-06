class Rating < ActiveRecord::Base
  belongs_to :rateable, polymorphic: true
  belongs_to :user

  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
  }
end
