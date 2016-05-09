require 'resque/failure/multiple'
require 'resque/failure/redis'
require 'resque/rollbar'

if Rails.env.development? || Rails.env.test?
  Resque.redis = ENV.fetch("REDIS_1_PORT").gsub("tcp://", "")
end

Resque::Failure::Multiple.classes = [
  Resque::Failure::Redis,
  Resque::Failure::Rollbar,
]
Resque::Failure.backend = Resque::Failure::Multiple
