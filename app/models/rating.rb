class Rating < ApplicationRecord
  belongs_to :rateable, polymorphic: true, touch: true
  belongs_to :user

  validates_with(
    PolymorphicAssociationValidator.new(name: :rateable, types: [Video, Move])
  )

  validates :user, :rateable, presence: true
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5,
  }
  validate :can_rate

  private

  def can_rate
    return unless user.present?
    return if UserWithRatingPermissions.new(user).can_rate?(rateable)

    errors.add(
      :base,
      "Cannot rate your own content or you've already rated this",
    )
  end
end
