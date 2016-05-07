require "rails_helper"

describe Activity do
  it { should belong_to :user }
  it { should belong_to :subject }

  it { should validate_presence_of :subject }
  it { should validate_presence_of :user }
end
