require "rails_helper"

feature "edit move" do
  scenario "edit move" do
    move = create :move, name: "Mocking Bird", description: "hi there"

    visit move_path(move, as: move.user)
    click_button "Edit"
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "stuff goes here"
    click_button "Update move"

    expect(page).to have_content "Sybil"
    expect(page).to have_content "stuff goes here"
  end

  scenario "doesn't see edit link if not owns move" do
    move = create :move

    visit move_path(move, as: create(:user))

    expect(page).not_to have_content "Edit"
  end
end
