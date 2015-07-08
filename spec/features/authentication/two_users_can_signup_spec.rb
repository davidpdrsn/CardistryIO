require "rails_helper"

feature "authentication" do
  scenario "two users sign up" do
    sign_up(
      email: "david.pdrsn@gmail.com",
      password: "passwordlol",
      username: "davidpdrsn",
    )
    click_link "Sign out"

    sign_up(
      email: "bob@gmail.com",
      password: "passwordlol",
      username: "bob",
    )

    expect(User.count).to eq 2
  end
end
