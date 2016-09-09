require "rails_helper"

describe NullUser do
  it "isn't an admin" do
    expect(NullUser.new.admin?).to eq false
  end

  it "has no videos" do
    expect(NullUser.new.videos).to eq []
  end

  it "can never rate anything" do
    expect(NullUser.new.can_rate?(Object.new)).to eq false
  end

  it "is not admin" do
    expect(NullUser.new.admin).to eq false
  end

  it "has no id" do
    expect(NullUser.new.id).to eq nil
  end
end
