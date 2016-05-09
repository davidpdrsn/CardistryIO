class WelcomeController < ApplicationController
  def index
    if signed_in?
      @feed = TimeSlots.new(
        Feed.new(current_user).activities
      )
      render "feeds/index"
    end
  end

  def test_resque_fail
    TestJob.perform_later

    head :ok
  end
end
