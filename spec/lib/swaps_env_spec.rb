require "rails_helper"

describe SwapsEnv do
  it "changes the env inside the block" do
    SwapsEnv.new.swap_for("development") do
      expect(Rails.env).to eq "development"
    end
  end

  it "calls the block" do
    probe = nil

    SwapsEnv.new.swap_for("development") do
      probe = Object.new
    end

    expect(probe).to_not be_nil
  end

  it "resets the env" do
    SwapsEnv.new.swap_for("development") do
    end

    expect(Rails.env).to eq "test"
  end

  it "returns the value from the block" do
    value = SwapsEnv.new.swap_for("development") do
      :hi_mom
    end

    expect(value).to eq :hi_mom
  end
end
