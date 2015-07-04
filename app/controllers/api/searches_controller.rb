module Api
  class SearchesController < Api::Controller
    def moves
      matches = Searcher.new(params[:query]).find_results
      render json: matches, root: false
    end
  end
end
