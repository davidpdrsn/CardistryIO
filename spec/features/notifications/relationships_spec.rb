require "rails_helper"

feature "relationships" do
  scenario "following a user" do
    bob = create :user
    alice = create :user, username: "alice"

    visit user_path(bob, as: alice)
    click_link "Follow"

    visit root_path(bob, as: bob)

    find("a", text: /started following you/).click

    expect(page).to have_content "@alice started following you"
  end
end
