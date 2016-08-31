class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :subject, polymorphic: true

  validates :subject, :user, presence: true

  validates_with(
    PolymorphicAssociationValidator.new(name: :subject, types: [Video, Move])
  )

  def name
    subject.name
  end

  def text
    name
  end
end
