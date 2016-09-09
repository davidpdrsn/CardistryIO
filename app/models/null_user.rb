class NullUser
  def admin?
    false
  end

  def videos
    []
  end

  def can_rate?(*)
    false
  end

  def admin
    false
  end

  def id
    nil
  end

  def ratings
    Rating.none
  end

  def already_rated?(_)
    false
  end
end
