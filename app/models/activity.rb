class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: true

  validates :subject, :user, presence: true
end
