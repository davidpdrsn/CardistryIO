require "rails_helper"

describe Comment do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :content }
  it { should validate_presence_of :user_id }
end
