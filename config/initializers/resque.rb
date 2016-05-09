redis = ENV.fetch("REDIS_1_PORT") do
  ENV.fetch("REDIS_URL")
end.gsub("tcp://", "")

Resque.redis = redis
