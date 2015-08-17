require "rails_helper"

feature "feed" do
  scenario "viewing the feed" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    bob.follow!(alice)

    visit new_move_path(as: alice)
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "Old school"
    click_button "Add move"

    visit root_path(as: bob)

    expect(page).to have_content "Sybil"
  end
end
