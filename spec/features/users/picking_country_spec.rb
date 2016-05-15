require "rails_helper"

feature "picking a country" do
  scenario "on edit" do
    user = create :user, country_code: "US"

    visit user_path(user, as: user)
    expect(page).to_not have_content("Denmark")

    visit edit_user_path(user, as: user)
    select "Denmark", from: "Country"
    click_button "Update User"
    visit user_path(user, as: user)

    expect(page).to have_content("Denmark")
  end
end
