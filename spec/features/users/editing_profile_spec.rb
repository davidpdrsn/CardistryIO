require "rails_helper"

feature "editing profile" do
  scenario "sets first and last name" do
    user = create :user, first_name: "foo", last_name: "bar"

    visit user_path(user, as: user)
    click_link "Edit"
    fill_in "First name", with: "Dave"
    fill_in "Last name", with: "Buck"
    fill_in "Instagram username", with: "kevho"
    click_button "Update User"

    expect(page).to have_content "Dave Buck"
    expect(page).to have_content "kevho"
  end
end
