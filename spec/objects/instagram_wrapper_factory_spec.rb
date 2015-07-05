require "rails_helper"

describe InstagramWrapperFactory do
  it "returns InstagramIO in production" do
    with_env("production") do
      wrapper = InstagramWrapperFactory.call

      expect(wrapper).to eq InstagramIO
    end
  end

  it "returns InstagramIO in development" do
    with_env("development") do
      wrapper = InstagramWrapperFactory.call

      expect(wrapper).to eq InstagramIO
    end
  end

  it "returns InstagramIOFake in test" do
    with_env("test") do
      wrapper = InstagramWrapperFactory.call

      expect(wrapper).to eq InstagramIOFake
    end
  end

  def with_env(env)
    original_env = Rails.env
    Rails.env = env
    yield
    Rails.env = original_env
  end
end
