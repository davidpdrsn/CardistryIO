class WithRatingStats < SimpleDelegator
  def average_rating
    ratings = rateable.ratings.map(&:rating)
    return 0 if ratings.empty?
    ratings.inject(0, :+).fdiv(ratings.count).round(1)
  end

  private

  def rateable
    __getobj__
  end
end
