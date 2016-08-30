class WelcomeController < ApplicationController
  def index
    if signed_in?
      @feed = TimeSlots.new(
        Feed.new(current_user).activities
      )
      render "feeds/index"
    end
  end

  def beta_signin
    if valid_beta_authentication?
      session[:beta_user] = true
      flash.clear
      redirect_to root_path
    else
      session[:beta_user] = nil
      flash.alert = "Wrong beta username or password"
      render layout: false
    end
  end

  def test_resque_fail
    TestJob.perform_later

    head :ok
  end

  private

  def valid_beta_authentication?
    params[:username] == ENV.fetch("PRE_USERNAME") &&
      params[:password] == ENV.fetch("PRE_PASSWORD")
  end
end
