class RelationshipsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]

  def create
    user = User.find(params[:id])

    if current_user.follows?(user)
      flash.alert = "You're already following #{user.username}"
      redirect_to user
    else
      relationship = current_user.follow!(user)
      if relationship.new?
        Notifier.new(user).new_follower(relationship: relationship)
      end
      flash.notice = "Now following #{user.username}"
      redirect_to user
    end
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow!(user)
    flash.notice = "Unfollowed #{user.username}"
    redirect_to user
  end

  def following
    @user = User.find(params[:id])
    title t("titles.relationships.following", username: @user.username)
  end

  def followers
    @user = User.find(params[:id])
    title t("titles.relationships.followers", username: @user.username)
  end
end
