class FiltersMoves
  pattr_initialize :moves

  def filter(params)
    filter = filter_params(params).require(:type)
    case filter
    when "idea"
      moves.ideas
    when "finished"
      moves.finished
    else
      moves
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
