class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true

  validates_with(
    PolymorphicAssociationValidator.new(name: :commentable,
                                        types: [Video, Move])
  )

  with_options(dependent: :destroy) do |c|
    c.has_many :notifications, as: :subject
  end

  def updated?
    updated_at != created_at
  end

  def commenting_on_own_commentable?
    commentable.user == user
  end
end
