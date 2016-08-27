# ENV["RAILS_ENV"] = "test"

# require File.expand_path("../../config/environment", __FILE__)

# require "rspec/rails"
# require "shoulda/matchers"
# require "clearance/rspec"

# Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

# module Features
#   # Extend this module in spec/support/features/*.rb
#   include Formulaic::Dsl
# end

# RSpec.configure do |config|
#   config.infer_base_class_for_anonymous_controllers = false
#   config.infer_spec_type_from_file_location!
#   config.use_transactional_fixtures = false

#   Capybara::Webkit.configure do |config|
#     config.debug = true
#   end
#   Capybara.javascript_driver = :webkit

#   ActiveRecord::Migration.maintain_test_schema!

#   Shoulda::Matchers.configure do |config|
#     config.integrate do |with|
#       with.test_framework :rspec
#       with.library :rails
#     end
#   end
# end


# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  Capybara.javascript_driver = :webkit
end
