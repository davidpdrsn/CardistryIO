require "rails_helper"

feature "feed" do
  scenario "with moves" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    bob.follow!(alice)

    visit new_move_path(as: alice)
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "Old school"
    click_button "Add move"

    visit root_path(as: bob)

    expect(page).to have_content "Sybil"
    expect(page).to have_content "Today"
    expect(page).not_to have_content "Last week"
  end

  scenario "with videos" do
    bob = create :user, username: "Bob"
    alice = create :user, username: "Alice"
    bob.follow!(alice)
    admin = create :user, admin: true
    video = create :video, name: "Air Time", user: alice, approved: false

    visit root_path(as: admin)
    click_link "Approve videos"
    click_button "Approve"
    click_link "All Videos"

    visit root_path(as: bob)
    expect(page).to have_content "Air Time"
  end

  scenario "deleting move" do
    bob = create :user, username: "Bob"

    visit new_move_path(as: bob)
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "Old school"
    click_button "Add move"

    visit move_path(Move.last, as: bob)
    click_button "Delete move"

    visit root_path(as: bob)

    expect(page).not_to have_content "Sybil"
  end
end
