class MonitorResqueJob < ApplicationJob
  def perform
    Rails.cache.write("monitor_resque_testing", "OK")
  end
end
