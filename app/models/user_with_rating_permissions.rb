class UserWithRatingPermissions < SimpleDelegator
  def can_rate?(rateable)
    not_already_rated(rateable) && not_rating_own_content?(rateable)
  end

  private

  def not_rating_own_content?(rateable)
    self != rateable.user
  end

  def not_already_rated(rateable)
    !already_rated?(rateable, type: rateable.class.name.downcase)
  end
end
