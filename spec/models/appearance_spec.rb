require "rails_helper"

describe Appearance do
  it { should belong_to :video }
  it { should belong_to :move }

  it { should validate_presence_of :move_id }
  it { should validate_presence_of :video_id }
end
