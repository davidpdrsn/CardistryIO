require "rails_helper"

describe Searcher do
  it "returns the moves that match" do
    create :move, name: "Sybil"
    move = create :move, name: "Mocking Bird"
    create :move, name: "Jackson 5"

    results = Searcher.new("Bird").find_results
    expect(results).to eq [move]
  end

  it "is case insensitive" do
    create :move, name: "Sybil"
    move = create :move, name: "Mocking Bird"
    create :move, name: "Jackson 5"

    results = Searcher.new("bird").find_results
    expect(results).to eq [move]
  end

  it "sorts the results alphabetically" do
    one = create :move, name: "Sybil a"
    three = create :move, name: "Sybil z"
    two = create :move, name: "Sybil m"

    results = Searcher.new("Sybil").find_results
    expect(results.map(&:id)).to eq [one, two, three].map(&:id)
  end
end
