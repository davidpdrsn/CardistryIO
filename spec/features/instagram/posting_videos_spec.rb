require "rails_helper"

feature "posting videos from instagram" do
  scenario "submitting a video and getting it approved" do
    bob = create :user
    visit root_path(as: bob)
    click_link "Import from Instagram"
    click_link "Share on CardistryIO"
    fill_in "Name", with: "Instagram video"
    select "Performance", from: "Type"
    click_button "Submit video"

    alice = create :user, admin: true
    visit root_path(as: alice)
    click_link "Approve videos"
    click_button "Approve"

    visit root_path(as: bob)
    click_link "Videos"
    click_link "Instagram video"

    expect(page).to have_content "Instagram video"
    expect(page).to have_content "Classic"
  end

  scenario "editing an instagram video" do
    bob = create :user
    visit root_path(as: bob)
    click_link "Import from Instagram"
    click_link "Share on CardistryIO"
    fill_in "Name", with: "Instagram video"
    select "Performance", from: "Type"
    click_button "Submit video"

    alice = create :user, admin: true
    visit root_path(as: alice)
    click_link "Approve videos"
    click_button "Approve"

    visit root_path(as: bob)
    click_link "Videos"
    click_link "Instagram video"
    click_button "Edit"
    fill_in "Name", with: "Edited video"
    click_button "Update video"

    expect(page).to have_content "Edited video"
  end

  scenario "it assigns the users instagram_username if he doesn't have one" do
    bob = create :user, instagram_username: nil
    visit root_path(as: bob)
    click_link "Import from Instagram"
    click_link "Share on CardistryIO"
    fill_in "Name", with: "Instagram video"
    select "Performance", from: "Type"
    click_button "Submit video"

    bob.reload
    expect(bob.instagram_username).to eq "kevho"
  end

  scenario "it doesn't change a users existing instagram username" do
    bob = create :user, instagram_username: "bob"
    visit root_path(as: bob)
    click_link "Import from Instagram"
    click_link "Share on CardistryIO"
    fill_in "Name", with: "Instagram video"
    select "Performance", from: "Type"
    click_button "Submit video"

    bob.reload
    expect(bob.instagram_username).to eq "bob"
  end
end
