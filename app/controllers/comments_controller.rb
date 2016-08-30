class CommentsController < ApplicationController
  before_action :require_login, only: [:create, :update, :edit]

  def create
    commentable = find_commentable
    comment = commentable.comments.new(comment_params)
    comment.user = current_user
    MentionNotifier.new(
      MentionNotifier::CommentAdapter.new(comment)
    ).notify_mentioned_users

    if comment.save
      create_notification(commentable)
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

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def create_notification(subject)
    Notifier.new(subject.user).comment(subject: subject, actor: current_user)
  end

  def ensure_user_made_comment(comment)
    if comment.user == current_user
      yield if block_given?
    else
      flash.alert = "You can only edit your own comments"
      redirect_to comment.commentable
    end
  end
end
