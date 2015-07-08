class RelationshipsController < ApplicationController
  before_filter :require_login

  def create
    user = User.find(params[:id])
    relationship = current_user.follow!(user)
    Notifier.new(user).new_follower(subject: relationship, actor: current_user)
    flash.notice = "Now following #{user.username}"
    redirect_to user
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow!(user)
    flash.notice = "Unfollowed #{user.username}"
    redirect_to user
  end

  def following
    @user = User.find(params[:id])
  end

  def followers
    @user = User.find(params[:id])
  end
end
