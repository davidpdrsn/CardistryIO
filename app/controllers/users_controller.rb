class UsersController < Clearance::UsersController
  before_action :require_login, only: [:edit, :update, :make_admin]
  before_action :has_access, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    user_params = params.require(:user).permit(
      :instagram_username,
      :biography,
      :time_zone,
      :email,
    )
    if @user.update(user_params)
      flash.notice = "Updated"
      redirect_to @user
    else
      flash.alert = "Not updated"
      render :edit
    end
  end

  def make_admin
    user = User.find(params[:id])
    ensure_user_is_admin!(user)
    user.update!(admin: true)
  end

  private

  def ensure_user_is_admin!(user)
    unless user.admin
      flash.alert = "Only admins can make new admins"
      redirect_to root_path
    end
  end

  def has_access
    if current_user.id != params[:id].to_i
      flash.alert = "Page not found"
      redirect_to root_path
    end
  end

  def user_from_params
    user_params = params.require(:user).permit(
      :email,
      :password,
      :username,
      :instagram_username,
      :time_zone,
    )
    Clearance.configuration.user_model.new(user_params)
  end
end
