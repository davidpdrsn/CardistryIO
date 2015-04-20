class MovesController < ApplicationController
  def all_moves
    @moves = Move.all
  end

  def index
    @moves = current_user.moves
  end

  def show
    @move = Move.find(params[:id])
  end

  def new
    @move = Move.new
  end

  def create
    move_params = params.require(:move).permit(:name)
    @move = Move.new(move_params)
    @move.user = current_user
    @move.save
    redirect_to @move, notice: "Move created"
  end
end
