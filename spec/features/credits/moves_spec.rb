require "rails_helper"

feature "creating move" do
  scenario "creates the move", :js do
    user = create :user, username: "davidpdrsn"
    visit new_move_path(as: user)
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "Old school"
    within ".add-credits" do
      fill_in "Username", with: "david"
      click_link "@davidpdrsn"
    end
    click_button "Add move"

    expect(page).to have_content "Sybil"
    within ".credits" do
      expect(page).to have_content "@davidpdrsn"
    end
  end
end
