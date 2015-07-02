class CommentsController < ApplicationController
  before_filter :require_login, only: [:create]

  def create
    commentable = find_commentable
    comment_params = params.require(:comment).permit(:content)
    comment = commentable.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      flash.notice = "Comment added"
      redirect_to commentable
    else
      flash.alert = "Comment was invalid"
      redirect_to commentable
    end
  end

  private

  def find_commentable
    if params[:move_id]
      Move.find(params[:move_id])
    else
      Video.find(params[:video_id])
    end
  end
end
