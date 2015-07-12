require "rails_helper"

describe Credit do
  it { should belong_to :creditable }
  it { should belong_to :user }
end
