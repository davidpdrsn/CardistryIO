class UsersController
  class MovesController < ApplicationController
    def index
      user = User.find(params[:user_id])
      @filter_submit_path = user_moves_path(user)
      @paged_moves = filter_sort_and_paginate(user.moves)
      title t("titles.users.moves.index")

      render "moves/index"
    end

    def filter_sort_and_paginate(moves)
      ListTransformer.new(
        relation: moves,
        params: params,
        filter_with: FiltersMoves,
        sort_with: SortsMoves,
      ).transform
    end
  end
end
