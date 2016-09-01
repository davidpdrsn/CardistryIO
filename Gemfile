source "https://rubygems.org"

ruby "2.3.0"

gem "rails", "5.0.0.1"

# Most at the top because other gems might depend on ENV being loaded
gem "dotenv-rails", require: "dotenv/rails-now"

gem "active_model_serializers"
gem "attr_extras"
gem "autoprefixer-rails"
gem "bourbon"
gem "capistrano"
gem "capistrano-bundler"
gem "capistrano-deploytags", "~> 1.0.0", require: false
gem "capistrano-rails"
gem "capistrano-rails-console"
gem "capistrano-rbenv"
gem "clearance"
gem "coffee-rails"
gem "email_validator"
gem "enum_help"
gem "flamegraph"
gem "flutie"
gem "gravtastic"
gem "haml-rails"
gem "high_voltage"
gem "i18n-tasks"
gem "instagram"
gem "ionicons-rails"
gem "jquery-rails"
gem "jquery-ui-rails"
gem "neat"
gem "normalize-rails"
gem "pg"
gem "puma"
gem "recipient_interceptor"
gem "redis-rails"
gem "refills"
gem "resque"
gem "rollbar"
gem "resque-rollbar"
gem "sass-rails"
gem "simple_form"
gem "country_select"
gem "skylight"
gem "stackprof"
gem "uglifier"
gem "seedbank"
gem "faker"

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", require: false
  gem "brakeman"
  gem "byebug"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails"
end

group :test do
  gem "capybara-webkit", ">= 1.2.0"
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rack-timeout"
end
