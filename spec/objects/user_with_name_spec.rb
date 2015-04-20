require "rails_helper"

describe UserWithName do
  describe "#name" do
    it "combines the first and last name" do
      user = double("user", first_name: "Dave", last_name: "Buck")
      user_with_name = UserWithName.new(user)

      expect(user_with_name.name).to eq "Dave Buck"
    end

    it "takes just the email if names are missing" do
      user = double(
        "user",
        first_name: nil,
        last_name: nil,
        email: "bob@example.com",
      )
      user_with_name = UserWithName.new(user)

      expect(user_with_name.name).to eq "bob@example.com"
    end

    it "takes just email if first name is missing" do
      user = double(
        "user",
        first_name: nil,
        last_name: "Buck",
        email: "bob@example.com",
      )
      user_with_name = UserWithName.new(user)

      expect(user_with_name.name).to eq "bob@example.com"
    end

    it "takes just email if last name is missing" do
      user = double(
        "user",
        first_name: "Dave",
        last_name: nil,
        email: "bob@example.com",
      )
      user_with_name = UserWithName.new(user)

      expect(user_with_name.name).to eq "bob@example.com"
    end
  end
end
