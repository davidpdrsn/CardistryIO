class VideoWithUser < ActiveRecordDecorator
  def initialize(video:, user:)
    super(video)
    @video = video
    @user = user
  end

  def author
    @user.username
  end

  def additional_attributes
    {
      runtime: '02:30',
      view_count: @video.unique_views_count,
      comment_count: @video.comments.count,
    }
  end
end
