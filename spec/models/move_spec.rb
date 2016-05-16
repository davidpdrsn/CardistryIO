require "rails_helper"

describe Move do
  it { should belong_to :user }
  it { should have_many :appearances }
  it { should have_many :comments }
  it { should have_many :ratings }
  it { should have_many :credits }

  it { should validate_presence_of :name }

  it "destroys appearances when its destroyed" do
    move = create :move
    create :appearance, move: move

    move.destroy

    expect(Appearance.count).to eq 0
  end

  describe "#creditted_users" do
    it "returns the users who have gotten credit for that move" do
      move = create :move
      user = create :user, username: "bob"
      create :user, username: "alice"
      Credit.create!(creditable: move, user: user)
      move.reload

      expect(move.creditted_users.map(&:username)).to eq [user.username]
    end
  end

  describe ".foreign_key" do
    it "returns the foreign key used for this table" do
      expect(Move.foreign_key).to eq "move_id"
    end
  end

  it "deletes its activites when it is deleted" do
    move = create :move
    Activity.create!(subject: move, user: move.user)

    expect do
      move.destroy!
    end.to change { Activity.count }.from(1).to(0)
  end

  describe ".ideas" do
    it "returns moves that are ideas" do
      move = create :move, idea: true

      expect(Move.ideas).to eq [move]
    end

    it "doesn't return moves that aren't ideas" do
      create :move, idea: false

      expect(Move.ideas).to eq []
    end
  end

  describe "order_by_rating" do
    it "sorts them desc" do
      two = create :move, name: "two"
      5.times { create :rating, rateable: two, rating: 3 }

      one = create :move, name: "one"
      5.times { create :rating, rateable: one, rating: 5 }

      three = create :move, name: "three"
      5.times { create :rating, rateable: three, rating: 1 }

      expect(Move.order_by_rating(:desc).map(&:name))
        .to eq ["one", "two", "three"]
    end
  end
end
