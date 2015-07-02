class Move < ActiveRecord::Base
  belongs_to :user
  has_many :appearances, dependent: :destroy
  has_many :comments, as: :commentable

  validates :name, presence: true, uniqueness: true
end
