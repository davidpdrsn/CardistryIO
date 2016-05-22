module Searcher
  class Videos < Base
    def find_results
      super.order(:name)
    end

    private

    def relation
      Video
    end

    def column
      "name"
    end
  end
end
