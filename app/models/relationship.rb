class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  def make_inactive!
    update!(active: false)
  end

  def make_active!
    update!(active: true)
  end
end
