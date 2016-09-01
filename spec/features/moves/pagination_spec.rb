require "rails_helper"

feature "pagination" do
  scenario "paging" do
    moves = 25.times.map do
      create :move
    end

    visit all_moves_path

    expect(page).to have_content moves.last.name
    expect(page).to_not have_content moves.first.name

    find("#pagination-forward").click

    expect(page).to have_content moves.first.name
    expect(page).to_not have_content moves.last.name

    find("#pagination-back").click

    expect(page).to have_content moves.last.name
    expect(page).to_not have_content moves.first.name
  end

  scenario "paging 'My Moves'" do
    user = create :user
    moves = 25.times.map do
      create :move, user: user
    end

    visit moves_path(as: user)

    expect(page).to have_content moves.last.name
    expect(page).to_not have_content moves.first.name

    find("#pagination-forward").click

    expect(page).to have_content moves.first.name
    expect(page).to_not have_content moves.last.name

    find("#pagination-back").click

    expect(page).to have_content moves.last.name
    expect(page).to_not have_content moves.first.name
  end
end
