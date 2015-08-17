class WelcomeController < ApplicationController
  def index
    if signed_in?
      @feed = Feed.new(current_user)
      render "feeds/index"
    end
  end
end
