class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, polymorphic: true

  validates :subject, :user, presence: true

  validates_with(
    PolymorphicAssociationValidator.new(name: :subject, types: [Video, Move])
  )
end
