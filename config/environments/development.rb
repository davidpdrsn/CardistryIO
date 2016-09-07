Rails.application.configure do
  config.action_controller.perform_caching = false
  config.cache_store = :null_store
  # config.action_controller.perform_caching = true
  # config.cache_store = :redis_store
  config.cache_classes = false

  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: "localhost:3000" }
end
