require 'resque/failure/multiple'
require 'resque/failure/redis'
require 'resque/rollbar'

if Rails.env.development?
  Resque.redis = 'redis:6379'
end

Resque::Failure::Multiple.classes = [
  Resque::Failure::Redis,
  Resque::Failure::Rollbar,
]
Resque::Failure.backend = Resque::Failure::Multiple

Resque.logger = Logger.new "log/resque.log"
