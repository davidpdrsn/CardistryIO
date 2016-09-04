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
end
