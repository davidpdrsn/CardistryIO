class TestJob < ApplicationJob
  def perform
    User.all.first!.touch
  end
end
