require "rails_helper"

describe User do
  it { should have_many :moves }
  it { should have_many :videos }

  it "is not admin by default" do
    expect(User.new.admin?).to eq false
  end
end
