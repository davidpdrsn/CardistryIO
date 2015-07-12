module Searcher
  class Users < Base
    def find_results
      super.order(:username)
    end

    private

    def relation
      User
    end

    def column
      "username"
    end
  end
end
