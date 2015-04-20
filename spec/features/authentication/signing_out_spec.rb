require "rails_helper"

feature "signing out" do
  scenario "user signs in" do
    sign_up email: "bob@example.com"
    click_link "Sign out"

    expect(page).to have_content "Sign up"
    expect(page).to have_content "Sign in"
    expect(page).not_to have_content "Sign out"
    expect(page).not_to have_content "bob@example.com"
  end
end
