class MovesController < ApplicationController
  before_action :require_login, only: [:new, :create, :index,
                                       :destroy, :edit, :update]

  def all
    moves = paginate(Move.order(created_at: :desc))

    @paged_moves = moves.map do |move|
      MoveWithUser.new(
        move: move,
        user: UserWithName.new(move.user),
      )
    end
  end

  def index
    @paged_moves = paginate(current_user.moves.order(created_at: :desc))
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
    @move = ObservableRecord.new(
      current_user.moves.new(move_params),
      CompositeObserver.new([
        Observers::NotifyMentions.new,
        Observers::AddsCredit.new(params, current_user),
        Observers::Activity.new,
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
    observer = Observers::AddsCredit.new(params, current_user)
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

  def page
    (params[:page] || 1).to_i
  end

  def paginate(moves)
    PaginatedRelation.new(
      moves,
      per_page: PaginatedRelation::DEFAULT_PER_PAGE,
    ).page(page)
  end
end
