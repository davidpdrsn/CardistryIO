class Move < ActiveRecord::Base
  belongs_to :user
  has_many :appearances, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
