require "rails_helper"

describe NullUser do
  it "isn't an admin" do
    expect(NullUser.new.admin?).to eq false
  end

  it "has no videos" do
    expect(NullUser.new.videos).to eq []
  end
end
