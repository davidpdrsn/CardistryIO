require "rails_helper"

feature "relationships" do
  scenario "following a user" do
    bob = create :user
    alice = create :user

    visit user_path(bob, as: alice)
    click_button "Follow"

    visit root_path(bob, as: bob)

    expect(page).to have_content "Notifications (1)"
  end
end
