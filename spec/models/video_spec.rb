require "rails_helper"

describe Video do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
end
