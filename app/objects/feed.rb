class Feed
  pattr_initialize :user

  def activities
    activities_for_feed = Activity
      .where(user_id: ids_of_users_for_feed)
      .sort_by { |activity| activity.subject.created_at }
      .reverse

    activities_for_feed.map do |activity|
      FeedActivity.new(activity)
    end
  end

  private

  def ids_of_users_for_feed
    user.following.pluck(:id) + [user.id]
  end
end
