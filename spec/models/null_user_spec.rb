require "rails_helper"

describe NullUser do
  it "isn't an admin" do
    expect(NullUser.new.admin?).to eq false
  end
end
