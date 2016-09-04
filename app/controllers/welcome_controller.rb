class WelcomeController < ApplicationController
  def index
    if signed_in?
      @feed = PaginatedRelation.new(
        Feed.new(current_user).activities,
        per_page: PaginatedRelation::DEFAULT_PER_PAGE,
      ).page(page)
      render "feeds/index"
    end
  end

  def beta_signin
    if valid_beta_authentication?
      session[:beta_user] = true
      flash.clear
      redirect_to URI.parse(params.fetch(:redirect_to, root_path)).path
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

  def page
    params.fetch(:page, 1).to_i
  end
end
