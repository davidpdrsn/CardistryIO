module Api
  class SearchesController < Api::Controller
    def moves
      matches = Searcher::Moves.new(params[:query]).find_results
      render json: matches, root: false
    end

    def users
      matches = Searcher::Users.new(params[:query]).find_results
      render json: matches, root: false
    end
  end
end
