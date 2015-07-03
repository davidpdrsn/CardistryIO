require "rails_helper"

feature "making new admins" do
  scenario "making a new admin" do
    bob = create :user, admin: false
    alice = create :user, admin: true

    visit user_path(bob, as: alice)
    click_link "Make admin"
    visit root_path(as: bob)

    expect(page).to have_content "Approve videos"
  end

  scenario "doesn't show the button if user isn't admin" do
    bob = create :user, admin: false
    alice = create :user, admin: false

    visit user_path(bob, as: alice)

    expect(page).to_not have_css("a", text: "Make admin")
  end

  scenario "doesn't show button if user is admin" do
    bob = create :user, admin: true
    alice = create :user, admin: true

    visit user_path(bob, as: alice)

    expect(page).to_not have_css("a", text: "Make admin")
  end
end
