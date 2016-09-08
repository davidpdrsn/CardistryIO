class FiltersNotViewedVideos
  pattr_initialize :base_filter, [:current_user!]

  def new(videos)
    @videos = videos
    self
  end

  def filter(params)
    query = base_filter.new(videos).filter(params)

    if params[:not_viewed]
      query.not_viewed_by(current_user)
    else
      query
    end
  end

  private

  attr_reader :videos
end
