class FiltersVideos
  pattr_initialize :videos

  def filter(params)
    filter = filter_params(params).require(:type)
    case filter
    when "all"
      videos
    when "featured"
      videos.featured
    else
      videos.where(video_type: filter)
    end
  end

  private

  def filter_params(params)
    params.require(:filter).permit(:type)
  rescue ActionController::ParameterMissing
    default_filter_params
  end

  def default_filter_params
    ActionController::Parameters.new(
      type: "all",
    ).permit!
  end
end
