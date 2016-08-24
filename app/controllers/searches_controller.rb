class SearchesController < ApplicationController
  def show
    @result_collections = [users, videos, moves]
  end

  private

  def users
    CollectionWithName.new(
      name: "Users",
      collection: Searcher::Users.new(query).find_results,
    )
  end

  def videos
    CollectionWithName.new(
      name: "Videos",
      collection: Searcher::Videos.new(query).find_results,
    )
  end

  def moves
    CollectionWithName.new(
      name: "Moves",
      collection: Searcher::Moves.new(query).find_results,
    )
  end

  def query
    params.fetch(:query) { "" }
  end
end
