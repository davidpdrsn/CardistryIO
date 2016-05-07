class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true

  validates_with(
    PolymorphicAssociationValidator.new(name: :commentable,
                                        types: [Video, Move])
  )

  def updated?
    updated_at != created_at
  end
end
