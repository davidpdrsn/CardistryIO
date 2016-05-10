require "rails_helper"

describe Credit do
  it { should belong_to :creditable }
  it { should belong_to :user }

  it "isn't valid if the same user is already credited" do
    creditable = create :move
    user = create :user
    create :credit, creditable: creditable, user: user
    creditable.reload

    credit = build :credit, creditable: creditable, user: user

    expect(credit).to_not be_valid
  end
end
