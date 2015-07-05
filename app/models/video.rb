class Video < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true

  belongs_to :user
  has_many :appearances, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :sharings

  scope :all_public, -> { approved.where(private: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

  def approve!
    update!(approved: true)
  end

  def from_instagram?
    url.include?("instagram")
  end
end
