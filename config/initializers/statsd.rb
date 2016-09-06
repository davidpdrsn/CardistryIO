$statsd = Statsd.new("localhost", 8125)

ActiveSupport::Notifications.subscribe(
  "process_action.action_controller"
) do |_name, start, finish, _id, payload|
  $statsd.increment("request.processed")

  if payload[:exception]
    $statsd.increment("request.exception")
  end

  process_time = ((finish - start) * 1000).round
  $statsd.histogram("request.processed.time", process_time)

  controller = payload[:controller].underscore
    .sub("_controller", "").tr("/", "_")
  action = payload[:action]
  $statsd.histogram(
    "request.processed.time.#{controller}.#{action}",
    process_time,
  )
end

ActiveSupport::Notifications.subscribe(
  "perform.active_job"
) do |_name, start, finish, _id, payload|
  if payload[:exception]
    $statsd.increment("job.exception")
  end

  process_time = ((finish - start) * 1000).round
  $statsd.histogram("job.processed.time", process_time)

  job_class = payload[:job].class.name.underscore.tr("/", "_")
  $statsd.histogram("job.processed.time.#{job_class}", process_time)
end

ActiveSupport::Notifications.subscribe("cache_generate.active_support") do
  $statsd.increment("cache.miss")
end

ActiveSupport::Notifications.subscribe("cache_fetch_hit.active_support") do
  $statsd.increment("cache.hit")
end
