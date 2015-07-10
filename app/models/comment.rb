class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true

  def updated?
    updated_at != created_at
  end
end
