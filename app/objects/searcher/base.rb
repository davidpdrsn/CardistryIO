module Searcher
  class Base
    def initialize(query)
      @query = query
    end

    def find_results
      relation.where("#{column} ILIKE ?", "%#{@query}%")
    end
  end
end
