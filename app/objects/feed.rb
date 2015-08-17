class Feed
  pattr_initialize :user

  def activities
    activities_for_feed = Activity
      .where(user_id: user.following.pluck(:id))
      .sort_by { |x| x.subject.created_at }.reverse

    activities_for_feed.map do |activity|
      FeedActivity.new(activity)
    end
  end

  private

  def t
    @__t ||= user.class.arel_table
  end

  class FeedActivity < SimpleDelegator
    def name
      subject.name
    end

    def text
      name
    end
  end
end
