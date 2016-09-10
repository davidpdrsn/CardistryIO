require "rails_helper"

feature "pagination" do
  scenario "paging" do
    moves = 25.times.map do
      create :move
    end

    visit moves_path

    expect(page).to have_content moves.last.name
    expect(page).to_not have_content moves.first.name

    find("#pagination-forward a").click

    expect(page).to have_content moves.first.name
    expect(page).to_not have_content moves.last.name

    find("#pagination-back a").click

    expect(page).to have_content moves.last.name
    expect(page).to_not have_content moves.first.name
  end

  scenario "paging 'My Moves'" do
    user = create :user
    moves = 25.times.map do
      create :move, user: user
    end

    visit user_moves_path(user, as: user)

    expect(page).to have_content moves.last.name
    expect(page).to_not have_content moves.first.name

    find("#pagination-forward a").click

    expect(page).to have_content moves.first.name
    expect(page).to_not have_content moves.last.name

    find("#pagination-back a").click

    expect(page).to have_content moves.last.name
    expect(page).to_not have_content moves.first.name
  end
end
