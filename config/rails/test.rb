Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false
  config.public_file_server.enabled = true
  config.public_file_server.headers = { 'Cache-Control' => "public, max-age=#{1.year.to_i}" }
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.delivery_method = :test
  config.active_support.test_order = :random
  config.active_support.deprecation = :stderr
  config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: "www.example.com" }
  config.active_job.queue_adapter = :inline
  config.middleware.use Clearance::BackDoor
end