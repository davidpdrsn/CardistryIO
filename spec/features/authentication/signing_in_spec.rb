require "rails_helper"

feature "signing in" do
  scenario "user signs up" do
    sign_up(
      email: "bob@example.com",
      username: "visualmadness",
    )

    expect(page).to_not have_content "Log in"
    expect(page).to_not have_content "Sign up"
    expect(page).to have_content "Sign out"

    user = User.last
    expect(user.email).to eq "bob@example.com"
    expect(user.username).to eq "visualmadness"
  end

  scenario "user signs up with invalid data" do
    sign_up email: ""

    expect(page).to have_content "can't be blank"
  end

  scenario "user signs in with email" do
    create :user, email: "bob@example.com", password: "secret"
    visit root_path
    click_link "Log in"
    fill_in "Email or username", with: "bob@example.com"
    fill_in "Password", with: "secret"
    click_button "Sign in"

    expect(page).to have_content "Sign out"
    expect(page).not_to have_content "Log in"
  end

  scenario "user signs in with username" do
    create :user, username: "bob", email: "bob@example.com", password: "secret"
    visit root_path
    click_link "Log in"
    fill_in "Email or username", with: "bob"
    fill_in "Password", with: "secret"
    click_button "Sign in"

    expect(page).to have_content "Sign out"
    expect(page).not_to have_content "Log in"
  end
end
