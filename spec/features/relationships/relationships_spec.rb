require "rails_helper"

feature "relationships" do
  scenario "following a user" do
    bob = create :user
    alice = create :user

    visit user_path(alice, as: bob)
    click_link "Follow"
    visit user_path(bob, as: bob)
    click_link "1 following"

    expect(page).to have_content alice.username
  end

  scenario "can't follow when logged in" do
    bob = create :user
    alice = create :user

    visit user_path(alice)

    expect(page).not_to have_css ".follow_actions"
  end

  scenario "can't follow self" do
    bob = create :user

    visit user_path(bob, as: bob)

    expect(page).not_to have_button "Follow"
  end

  scenario "unfollowing" do
    bob = create :user
    alice = create :user

    visit user_path(alice, as: bob)
    click_link "Follow"
    visit user_path(alice, as: bob)
    click_link "Unfollow"
    visit user_path(bob, as: bob)
    click_link "0 following"

    expect(page).not_to have_content alice.username
  end

  scenario "can't unfollow when not following" do
    bob = create :user
    alice = create :user

    visit user_path(alice, as: bob)

    expect(page).to_not have_button "Unfollow"
  end

  scenario "can't follow when following" do
    bob = create :user
    alice = create :user
    bob.follow!(alice)

    visit user_path(alice, as: bob)

    expect(page).to_not have_button "Follow"
  end

  scenario "viewing followers" do
    bob = create :user
    alice = create :user
    alice.follow!(bob)

    visit user_path(bob)
    click_link "1 followers"

    expect(page).to have_content alice.username
  end
end
