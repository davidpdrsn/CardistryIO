class VideoWithUser < ActiveRecordDecorator
  include ActionView::Helpers::TextHelper

  attr_accessor :video, :user

  def initialize(video:, user:)
    super(video)
    @video = video
    @user = user
  end

  def author
    truncate(user.username, length: 15)
  end

  def name
    truncate(video.name, length: 12)
  end

  def additional_attributes
    {
      'views' => video.unique_views_count,
      'comments' => video.comments.count,
      'average-ratings' => video.average_rating,
      'total-ratings' => video.ratings.count
    }
  end

end
