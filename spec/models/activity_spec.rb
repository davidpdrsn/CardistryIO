require "rails_helper"

describe Activity do
  it { should belong_to :user }
  it { should belong_to :subject }
end
