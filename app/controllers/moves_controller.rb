class MovesController < ApplicationController
  before_action :require_login, only: [:new, :create, :index,
                                       :destroy, :edit, :update]

  def all
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

    respond_to do |format|
      format.html {}
      format.json {
        render json: @move, serializer: MoveSerializer, root: false
      }
    end
  end

  def new
    @move = Move.new
  end

  def create
    @move = current_user.moves.new(move_params)

    @move.transaction do
      MentionNotifier.new(@move).check_for_mentions
      @move.save!
      users = AddsCredits.new(@move).add_credits(params[:credits])
      notifier_users_of_new_credit(users, @move)

      flash.notice = "Move created"
      redirect_to @move
    end
  rescue ActiveRecord::ActiveRecordError
    flash.alert = "There were errors"
    render :new
  end

  def edit
    @move = current_user.moves.find(params[:id])
  end

  def update
    @move = current_user.moves.find(params[:id])

    begin
      @move.transaction do
        @move.update!(move_params)
        users = AddsCredits.new(@move).update_credits(params[:credits])
        notifier_users_of_new_credit(users, @move)
        flash.notice = "Updated"
        redirect_to @move
      end
    rescue ActiveRecord::ActiveRecordError
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

  def notifier_users_of_new_credit(users, move)
    users.each do |user|
      Notifier.new(user).new_credit(subject: move, actor: current_user)
    end
  end
end
