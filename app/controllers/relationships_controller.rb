class RelationshipsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]

  def create
    user = User.find(params[:id])
    relationship = current_user.follow!(user)

    if relationship.new?
      Notifier.new(user).new_follower(subject: relationship, actor: current_user)
    end

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
