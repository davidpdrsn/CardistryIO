class CommentsController < ApplicationController
  before_filter :require_login, only: [:create]

  def create
    move = Move.find(params[:move_id])
    comment_params = params.require(:comment).permit(:content)
    comment = move.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      flash.notice = "Comment added"
      redirect_to move
    else
      flash.alert = "Comment was invalid"
      redirect_to move
    end
  end
end
