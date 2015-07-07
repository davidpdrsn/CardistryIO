require "rails_helper"

describe MoveWithUser do
  describe "#name" do
    it "includes the name of the user" do
      raw_move = double("move", name: "Sybil")
      user = double("user", username: "david")

      move = MoveWithUser.new(
        move: raw_move,
        user: user,
      )

      expect(move.name).to eq "Sybil by david"
    end
  end
end
