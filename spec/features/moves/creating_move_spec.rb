require "rails_helper"

feature "creating move" do
  let(:user) { create :user }

  scenario "creates the move" do
    visit root_path(as: user)
    click_link "Add move"
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "Old school"
    click_button "Add move"

    expect(page).to have_content "Move created"
    expect(page).to have_content "Sybil"
    expect(page).to have_content "Old school"
  end

  scenario "creates invalid move" do
    visit root_path(as: user)
    click_link "Add move"
    fill_in "Name", with: ""
    click_button "Add move"

    expect(page).to have_content "can't be blank"
  end

  scenario "sees users moves" do
    create :move, name: "Sybil", user: user
    visit root_path(as: user)
    click_link "My moves"

    expect(page).to have_content "Sybil"
  end

  scenario "sees all moves" do
    user = create :user, username: "davidpdrsn"
    create :move, name: "Mocking Bird"
    create :move, name: "Sybil", user: user
    visit root_path(as: user)
    click_link "All moves"

    expect(page).to have_css :a, "Sybil by davidpdrsn"
    expect(page).to have_css :a, text: "Mocking Bird"
  end

  scenario "can't create without being logged in" do
    visit root_path

    expect(page).not_to have_css :a, text: "Add move"
    expect(page).not_to have_css :a, text: "My moves"
  end
end
