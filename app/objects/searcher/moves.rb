module Searcher
  class Moves < Base
    def find_results
      super.order(:name)
    end

    private

    def relation
      Move
    end

    def column
      "name"
    end
  end
end
