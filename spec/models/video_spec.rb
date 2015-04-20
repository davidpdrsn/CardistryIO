require "rails_helper"

describe Video do
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should belong_to :user }
  it { should have_many :appearances }
end
