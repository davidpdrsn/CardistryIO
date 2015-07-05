require "rails_helper"

feature "signing in" do
  scenario "user signs up" do
    sign_up(
      email: "bob@example.com",
      username: "visualmadness",
      first_name: "Kevin",
      last_name: "Ho",
      instagram_username: "kevho",
    )

    expect(page).to_not have_content "Sign in"
    expect(page).to_not have_content "Sign up"
    expect(page).to have_content "Sign out"
    expect(page).to have_content "Kevin Ho"

    user = User.last
    expect(user.email).to eq "bob@example.com"
    expect(user.username).to eq "visualmadness"
    expect(user.first_name).to eq "Kevin"
    expect(user.last_name).to eq "Ho"
    expect(user.instagram_username).to eq "kevho"
  end

  scenario "user signs up with invalid data" do
    sign_up email: ""

    expect(page).to have_content "is invalid"
  end

  scenario "user signs in" do
    create :user, email: "bob@example.com", password: "secret"
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: "bob@example.com"
    fill_in "Password", with: "secret"
    click_button "Sign in"

    expect(page).to have_content "Sign out"
    expect(page).not_to have_content "Sign in"
  end
end
