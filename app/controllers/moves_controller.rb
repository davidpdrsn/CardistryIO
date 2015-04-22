class MovesController < ApplicationController
  before_filter :require_login, only: [:new, :create, :index,
                                       :destroy, :edit, :update]

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
    @move = current_user.moves.new(move_params)

    if @move.save
      flash.notice = "Move created"
      redirect_to @move
    else
      flash.alert = "There were errors"
      render :new
    end
  end

  def edit
    @move = current_user.moves.find(params[:id])
  end

  def update
    @move = current_user.moves.find(params[:id])

    if @move.update(move_params)
      flash.notice = "Updated"
      redirect_to @move
    else
      flash.alert = "There were errors"
      render :new
    end
  end

  def destroy
    move = current_user.moves.find(params[:id])
    move.destroy
    flash.notice = "Move deleted"
    redirect_to root_path
  end

  private

  def move_params
    params.require(:move).permit(:name, :description)
  end
end
