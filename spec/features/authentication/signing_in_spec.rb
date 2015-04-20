require "rails_helper"

feature "signing in" do
  scenario "user signs in" do
    sign_up email: "bob@example.com"

    expect(page).to_not have_content "Sign in"
    expect(page).to_not have_content "Sign up"
    expect(page).to have_content "Sign out"
    expect(page).to have_content "bob@example.com"
  end
end
