require "rails_helper"

describe Relationship do
  it { should belong_to :follower }
  it { should belong_to :followee }

  it "is active by default" do
    expect(Relationship.new.active).to eq true
  end

  describe "#make_inactive!" do
    it "makes the relationship inactive" do
      relationship = Relationship.create!(
        followee_id: 123,
        follower_id: 123,
      )

      relationship.make_inactive!

      expect(relationship.active).to eq false
    end
  end

  describe "#make_active!" do
    it "makes the relationship active" do
      relationship = Relationship.create!(
        followee_id: 123,
        follower_id: 123,
        active: false,
      )

      relationship.make_active!

      expect(relationship.active).to eq true
    end
  end
end
