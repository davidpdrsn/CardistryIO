require "rails_helper"

describe "moves/index.haml" do
  it "shows when there are moves" do
    move = build_stubbed :move
    assign :moves, [move]

    render

    expect(rendered).to match move.name
  end

  it "shows when there are no moves" do
    assign :moves, []

    render

    expect(rendered).to match "You have no moves, yet"
  end
end
