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
    mention_observer = MentionNotificationObserver.new
    adds_credit_observer = AddsCreditObserver.new(params, current_user)

    @move = ObservableRecord.new(
      current_user.moves.new(move_params),
      CompositeObserver.new([
        mention_observer,
        adds_credit_observer,
      ]),
    )

    begin
      @move.transaction do
        @move.save!
        flash.notice = "Move created"
        redirect_to @move
      end
    rescue ActiveRecord::ActiveRecordError
      flash.alert = "There were errors"
      render :new
    end
  end

  def edit
    @move = current_user.moves.find(params[:id])
  end

  def update
    observer = AddsCreditObserver.new(params, current_user)
    @move = ObservableRecord.new(
      current_user.moves.find(params[:id]),
      observer,
    )

    begin
      @move.transaction do
        @move.update!(move_params)
        flash.notice = "Updated"
        redirect_to @move
      end
    rescue ActiveRecord::ActiveRecordError
      flash.alert = "There were errors"
      render :edit
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

  class MentionNotificationObserver
    def save!(move)
      MentionNotifier.new(move).notify_mentioned_users
    end
  end

  class AddsCreditObserver
    pattr_initialize :params, :current_user

    def save!(move)
      find_users_with_credits_for(move, then: :add_credits)
    end

    def update!(move, _)
      find_users_with_credits_for(move, then: :update_credits)
    end

    private

    def find_users_with_credits_for(move, options)
      method_name = options.fetch(:then)
      users = AddsCredits.new(move).public_send(method_name, params[:credits])
      notifier_users_of_new_credit(users, move)
    end

    def notifier_users_of_new_credit(users, move)
      users.each do |user|
        Notifier.new(user).new_credit(subject: move, actor: current_user)
      end
    end
  end
end
