require "rails_helper"

describe VideoView do
  it { should belong_to :user }
  it { should belong_to :video }
end
