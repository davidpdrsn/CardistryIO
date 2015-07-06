require "rails_helper"

describe Rating do
  it { should belong_to :rateable }
  it { should belong_to :user }

  it { should validate_numericality_of :rating }
end
