require "rails_helper"

describe Rating do
  it { should belong_to :rateable }
  it { should belong_to :user }

  it { should validate_numericality_of :rating }
  it { should validate_presence_of :user }
  it { should validate_presence_of :rateable }
end
