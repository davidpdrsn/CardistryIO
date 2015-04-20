class MovesController < ApplicationController
  before_filter :require_login, only: [:new, :create, :index]

  def all_moves
    @moves = Move.all.map do |move|
      MoveWithUser.new(
        move: move,
        user: UserWithName.new(move.user),
      )
    end
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
    move_params = params.require(:move).permit(:name, :description)
    @move = current_user.moves.new(move_params)

    if @move.save
      flash.notice = "Move created"
      redirect_to @move
    else
      flash.alert = "There were errors"
      render :new
    end
  end
end
