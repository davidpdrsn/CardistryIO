class Feature < ApplicationRecord
  belongs_to :featureable, polymorphic: true

  validates :featureable_type, :featureable_id, presence: true

  validates_with(
    PolymorphicAssociationValidator.new(name: :featureable, types: [Video])
  )
end
