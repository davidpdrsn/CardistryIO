class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  with_options(dependent: :destroy) do |c|
    c.has_many :notifications, as: :subject
  end

  def make_inactive!
    update!(active: false)
  end

  def make_active!
    update!(active: true)
  end
end
