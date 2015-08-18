class WelcomeController < ApplicationController
  def index
    if signed_in?
      @feed = TimeSlots.new(
        Feed.new(current_user).activities
      )
      render "feeds/index"
    end
  end
end
