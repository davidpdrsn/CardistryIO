class RelationshipsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]

  def create
    user = User.find(params[:id])

    unless current_user.follows?(user)
      relationship = current_user.follow!(user)
      if relationship.new?
        Notifier.new(user).new_follower(relationship: relationship)
      end
    end

    respond_to do |format|
      format.html { redirect_to user }
      format.js {
        @user = user
        render layout: false
      }
    end
  end

  def destroy
    user = User.find(params[:id])
    current_user.unfollow!(user)

    respond_to do |format|
      format.html { redirect_to user }
      format.js {
        @user = user
        render :create, layout: false
      }
    end
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
