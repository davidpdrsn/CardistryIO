require "rails_helper"

feature "search" do
  scenario "searching for users" do
    user = create :user, username: "darenyeow"

    visit root_path

    fill_in "query", with: "daren"
    click_button "Search"

    expect(page).to have_content "Users"
    expect(page).to have_link "@darenyeow"
  end

  scenario "searching for moves" do
    move = create :move, name: "Mocking Bird"

    visit root_path

    fill_in "query", with: "mocking"
    click_button "Search"

    expect(page).to have_content "Moves"
    expect(page).to have_link "Mocking Bird"
  end

  scenario "searching for videos" do
    create :video, name: "Airtime"

    visit root_path

    fill_in "query", with: "air"
    click_button "Search"

    expect(page).to have_content "Videos"
    expect(page).to have_link "Airtime"
  end

  scenario "when there are no results" do
    visit root_path

    fill_in "query", with: "air"
    click_button "Search"

    expect(page).to have_content "No results"
  end

  scenario "searching for empty string" do
    visit root_path

    click_button "Search"

    expect(page).to have_content "No results"
  end
end
