class SortsMoves
  pattr_initialize :moves

  def sort(params)
    sort_direction = sort_params(params).require(:direction)
    case sort_params(params).require(:by)
    when "created_at"
      moves.order(created_at: sort_direction)
    when "rating"
      moves.order_by_rating(sort_direction)
    else
      raise "Unsupported sorting"
    end
  end

  private

  def sort_params(params)
    params.require(:sort).permit(:by, :direction)
  rescue ActionController::ParameterMissing
    default_sort_params
  end

  def default_sort_params
    ActionController::Parameters.new(
      by: "created_at",
      direction: "DESC",
    ).permit!
  end
end
