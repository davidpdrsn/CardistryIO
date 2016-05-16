class OrdersByRatings
  pattr_initialize :relation

  def self.sanitize_sort_direction(direction)
    direction = direction.to_s.upcase
    if direction == "ASC"
      direction
    else
      "DESC"
    end
  end

  def order(direction)
    direction = self.class.sanitize_sort_direction(direction)

    relation.joins(:ratings)
      .group("#{table_name}.id")
      .having("count(#{table_name}.id) >= ?", relation::MINIMUM_NUMBER_OF_RATINGS)
      .order("AVG(ratings.rating) #{direction}")
  end

  private

  def table_name
    relation.table_name
  end
end
