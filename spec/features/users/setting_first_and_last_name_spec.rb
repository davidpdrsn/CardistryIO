require "rails_helper"

feature "setting first and last name" do
  scenario "sets first and last name" do
    user = create :user, first_name: nil, last_name: nil

    visit root_path(as: user)
    click_link user.email
    click_link "Edit"
    fill_in "First name", with: "Dave"
    fill_in "Last name", with: "Buck"
    click_button "Update User"

    expect(page).to have_content "Dave Buck"
  end
end
