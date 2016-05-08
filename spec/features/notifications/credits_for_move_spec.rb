require "rails_helper"

feature "move" do
  scenario "notifiers users", :js do
    user = create :user, username: "davidpdrsn"
    bob = create :user, username: "bob"
    visit new_move_path(as: user)
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "Old school"
    within ".add-credits" do
      fill_in "Username", with: "bob"
      click_link "@bob"
    end
    click_button "Add move"

    visit root_path(as: bob)

    expect(page).to have_content "@#{user.username} credited you for his move"

    click_link "move"
    expect(page).to have_content "Sybil"
  end
end
