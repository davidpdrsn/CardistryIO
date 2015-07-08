require "rails_helper"

describe Relationship do
  it { should belong_to :follower }
  it { should belong_to :followee }
end
