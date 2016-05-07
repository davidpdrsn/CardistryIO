ENV["RAILS_ENV"] = "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "shoulda/matchers"
require "clearance/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include Formulaic::Dsl
end

RSpec.configure do |config|
  config.include Features, type: :feature
  config.include HttpAuthenticationRequestHelpers, type: :request
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false
end

Capybara::Webkit.configure do |config|
  [
    "https://www.youtube.com",
    "https://secure.gravatar.com",
    "http://vjs.zencdn.net",
  ].each do |url|
    config.block_url(url)
  end
end


ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
