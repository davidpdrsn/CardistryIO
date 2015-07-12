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

  scenario "edits the move", :js do
    user = create :user, username: "davidpdrsn"
    create :user, username: "bob"
    visit new_move_path(as: user)
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "Old school"
    within ".add-credits" do
      fill_in "Username", with: "david"
      click_link "@davidpdrsn"
    end
    click_button "Add move"
    click_button "Edit"

    within ".add-credits" do
      click_button "Remove"
      fill_in "Username", with: "bob"
      click_link "@bob"
    end
    click_button "Update move"

    expect(page).to have_content "Sybil"
    within ".credits" do
      expect(page).to have_content "@bob"
    end
  end
end
