class UsersController < ApplicationController
  before_filter :require_login, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    user_params = params.require(:user).permit(:first_name, :last_name)
    @user.update(user_params)
    flash.notice = "Updated"
    redirect_to @user
  end
end
