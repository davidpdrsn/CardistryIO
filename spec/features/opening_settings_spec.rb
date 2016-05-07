require "rails_helper"

feature "opening settings" do
  scenario "" do
    user = create :user

    visit root_path(as: user)
    click_link "Settings"

    expect(page).to have_content "Update profile"
  end
end
