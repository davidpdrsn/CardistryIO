class Feed
  pattr_initialize :user

  def activities
    activities_for_feed = Activity
      .where(user_id: ids_of_users_for_feed)
      .joins("LEFT JOIN moves ON activities.subject_id = moves.id AND activities.subject_type = 'Move'")
      .joins("LEFT JOIN videos ON activities.subject_id = videos.id AND activities.subject_type = 'Video'")
      .order("COALESCE(moves.created_at, videos.created_at) DESC")
  end

  private

  def ids_of_users_for_feed
    user.following.pluck(:id) + [user.id]
  end
end
