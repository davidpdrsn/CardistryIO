class MonitorController < ApplicationController
  skip_around_action :require_beta_authentication

  def services
    errors = []

    test_cache(errors)
    test_database(errors)
    test_resque(errors)

    if errors.empty?
      # render plain: "OK"
      render plain: "Simulating error, but really everything is fine"
    else
      render plain: errors.join(", "), status: :internal_server_error
    end
  rescue => e
    render(
      plain: "#{e.message}\n\n#{e.backtrace.join("\n").indent(2)}",
      status: :internal_server_error,
    )
  end

  def stats
    @stats = VpsStats.new
  end

  private

  def test_cache(errors)
    Rails.cache.write("monitor_testing", "OK")

    unless Rails.cache.read("monitor_testing") == "OK"
      errors << "Cache down"
    end
  end

  def test_database(errors)
    unless User.all.count >= 1
      errors << "Database down"
    end
  end

  def test_resque(errors)
    resque_working = false
    Rails.cache.write("monitor_resque_testing", nil)

    MonitorResqueJob.perform_later

    9.times do
      if Rails.cache.read("monitor_resque_testing") == "OK"
        resque_working = true
        break
      end
      sleep 1
    end

    unless resque_working
      errors << "Resque down"
    end
  end
end
