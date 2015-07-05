require "rails_helper"

describe User do
  it { should have_many :moves }
  it { should have_many :videos }
  it { should have_many :comments }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :encrypted_password }
  it { should validate_presence_of :username }

  it "validates uniquess of username" do
    bob = create :user

    expect do
      create :user, username: bob.username
    end.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "is not admin by default" do
    expect(User.new.admin?).to eq false
  end
end
