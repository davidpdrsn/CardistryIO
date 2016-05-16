class MovesController < ApplicationController
  before_action :require_login, only: [:new, :create, :index,
                                       :destroy, :edit, :update]

  def all
    moves = filter_sort_and_paginate(Move.all)

    @filter_submit_path = all_moves_path
    @paged_moves = moves.map do |move|
      MoveWithUser.new(
        move: move,
        user: UserWithName.new(move.user),
      )
    end
  end

  def index
    @filter_submit_path = moves_path
    @paged_moves = filter_sort_and_paginate(current_user.moves)
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
    params.require(:move).permit(
      :name,
      :description,
      :idea,
    )
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
