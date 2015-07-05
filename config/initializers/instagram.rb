Instagram.configure do |config|
  config.client_id = ENV.fetch("INSTAGRAM_CLIENT_ID")
  config.client_secret = ENV.fetch("INSTAGRAM_CLIENT_SECRET")
end
