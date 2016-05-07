require "rails_helper"

feature "editing profile" do
  scenario "sets first and last name" do
    user = create :user, username: "davidpdrsn"

    visit user_path(user, as: user)
    click_link "Edit"
    fill_in "Instagram username", with: "kevho"
    click_button "Update User"

    expect(page).to have_content "davidpdrsn"
    expect(page).to have_content "kevho"
  end

  scenario "sets biography" do
    user = create :user, biography: "Nothing to see here"

    visit user_path(user, as: user)
    click_link "Edit"
    fill_in "Biography", with: "New biography!"
    click_button "Update User"

    expect(page).to have_content "New biography!"
  end
end
