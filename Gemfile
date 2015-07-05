source "https://rubygems.org"

ruby "2.2.2"

gem "active_model_serializers"
gem "airbrake"
gem "autoprefixer-rails"
gem "bourbon", "~> 4.2.0"
gem "capistrano"
gem "capistrano-bundler"
gem "capistrano-passenger"
gem "capistrano-rails"
gem "capistrano-rbenv"
gem "clearance"
gem "coffee-rails", "~> 4.1.0"
gem "delayed_job_active_record"
gem "email_validator"
gem "figaro"
gem "flutie"
gem "gravtastic"
gem "haml-rails"
gem "high_voltage"
gem "i18n-tasks"
gem "instagram"
gem "jquery-rails"
gem "neat", "~> 1.7.0"
gem "newrelic_rpm", ">= 3.9.8"
gem "normalize-rails", "~> 3.0.0"
gem "pg"
gem "rails", "4.2.2"
gem "recipient_interceptor"
gem "refills"
gem "sass-rails", "~> 5.0"
gem "simple_form"
gem "title"
gem "uglifier"
gem "unicorn"

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bundler-audit", require: false
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.1.0"
end

group :test do
  gem "capybara-webkit", ">= 1.2.0"
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rack-timeout"
end
