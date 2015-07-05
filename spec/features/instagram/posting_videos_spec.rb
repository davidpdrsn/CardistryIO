require "rails_helper"

feature "posting videos from instagram" do
  scenario "submitting a video and getting it approved" do
    bob = create :user
    visit root_path(as: bob)
    click_link "Submit videos from Instagram"
    click_link "Share on CardistryIO"
    fill_in "Name", with: "Instagram video"
    click_button "Submit video"

    alice = create :user, admin: true
    visit root_path(as: alice)
    click_link "Approve videos"
    click_button "Approve"

    visit root_path(as: bob)
    click_link "My videos"
    click_link "Instagram video"

    expect(page).to have_content "Instagram video"
    expect(page).to have_content "Classic"
  end

  scenario "editing an instagram video" do
    bob = create :user
    visit root_path(as: bob)
    click_link "Submit videos from Instagram"
    click_link "Share on CardistryIO"
    fill_in "Name", with: "Instagram video"
    click_button "Submit video"

    alice = create :user, admin: true
    visit root_path(as: alice)
    click_link "Approve videos"
    click_button "Approve"

    visit root_path(as: bob)
    click_link "My videos"
    click_link "Instagram video"
    click_button "Edit"
    fill_in "Name", with: "Edited video"
    click_button "Update video"

    expect(page).to have_content "Edited video"
  end
end
