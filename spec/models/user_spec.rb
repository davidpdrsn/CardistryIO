require "rails_helper"

describe User do
  it { should have_many :moves }
  it { should have_many :videos }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :encrypted_password }

  it "is not admin by default" do
    expect(User.new.admin?).to eq false
  end
end
