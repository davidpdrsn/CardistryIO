class Searcher
  def initialize(query)
    @query = query
  end

  def find_results
    Move.where("name ILIKE ?", "%#{@query}%").order(:name)
  end
end
