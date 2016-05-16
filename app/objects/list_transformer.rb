class ListTransformer
  pattr_initialize [:relation!, :params!, :filter_with!, :sort_with!]

  def transform
    paginate(apply_sort(apply_filter(relation)))
  end

  private

  def paginate(relation)
    PaginatedRelation.new(
      relation,
      per_page: PaginatedRelation::DEFAULT_PER_PAGE,
    ).page(page)
  end

  def apply_sort(relation)
    sort_with.new(relation).sort(params)
  end

  def apply_filter(relation)
    filter_with.new(relation).filter(params)
  end

  def page
    (params[:page] || 1).to_i
  end
end
