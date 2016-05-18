require "rails_helper"

feature "editing profile" do
  scenario "sets biography" do
    user = create :user, biography: "Nothing to see here"

    visit user_path(user, as: user)
    click_link "Edit"
    fill_in "Biography", with: "New biography!"
    click_button "Update User"

    expect(page).to have_content "New biography!"
  end

  scenario "sets email" do
    user = create :user, email: "bob@example.com"

    visit user_path(user, as: user)
    click_link "Edit"
    fill_in "Email", with: "alice@example.com"
    click_button "Update User"

    user.reload
    expect(user.email).to eq "alice@example.com"
  end
end

feature "link to edit profile" do
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
