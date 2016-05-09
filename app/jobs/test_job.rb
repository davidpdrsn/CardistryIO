class TestJob < ApplicationJob
  def perform
    raise "It works if you see this"
  end
end
