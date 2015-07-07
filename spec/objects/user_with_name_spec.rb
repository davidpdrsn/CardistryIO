require "rails_helper"

describe UserWithName do
  describe "#name_for_select" do
    it "combines the name and username" do
      user = double(
        "user",
        username: "visualmadness",
      )
      user_with_name = UserWithName.new(user)

      expect(user_with_name.name_for_select).to eq "visualmadness"
    end
  end
end
