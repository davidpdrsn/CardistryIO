module TestData
  def self.ensure_not_production_env!
    raise "Only works in development and test" if Rails.env.production?
  end
end
