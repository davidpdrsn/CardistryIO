class PaginatedRelation
  pattr_initialize :relation, [:per_page!]

  def page(count)
    relation
      .offset(per_page * (count - 1))
      .limit(per_page)
  end
end
