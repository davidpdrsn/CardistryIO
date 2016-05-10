class Credit < ApplicationRecord
  belongs_to :creditable, polymorphic: true
  belongs_to :user

  validates_with(
    PolymorphicAssociationValidator.new(name: :creditable, types: [Video, Move])
  )
  validates_with SingleCreditPerUser
end
