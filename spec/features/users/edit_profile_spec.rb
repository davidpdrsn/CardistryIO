require "rails_helper"

feature "edit user profile" do
  scenario "sees edit link" do
    bob = create :user

    visit user_path(bob, as: bob)

    expect(page).to have_content "Edit"
  end

  scenario "doesn't see edit link if viewing another users profile" do
    bob = create :user
    alice = create :user

    visit user_path(alice, as: bob)

    expect(page).not_to have_content "Edit"
  end
end
