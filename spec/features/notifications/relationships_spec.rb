require "rails_helper"

feature "relationships" do
  scenario "following a user" do
    bob = create :user
    alice = create :user, username: "alice"

    visit user_path(bob, as: alice)
    click_link "Follow"

    visit root_path(bob, as: bob)

    expect(page).to have_css("a", text: /started following you/)
  end
end
