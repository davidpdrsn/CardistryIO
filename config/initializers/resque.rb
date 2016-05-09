if Rails.env.development? || Rails.env.test?
  Resque.redis = ENV.fetch("REDIS_1_PORT")
end
