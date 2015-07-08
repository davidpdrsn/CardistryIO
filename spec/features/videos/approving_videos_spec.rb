require "rails_helper"

feature "approving videos" do
  scenario "admin approves a video" do
    admin = create :user, admin: true
    video = create :video, approved: false

    visit root_path(as: admin)
    click_link "All videos"

    expect(page).not_to have_content video.name

    click_link "Approve videos"
    click_button "Approve"
    click_link "All videos"

    expect(page).to have_content video.name
  end

  scenario "can't see link as non-admin" do
    user = create :user, admin: false
    visit root_path(as: user)

    expect(page).not_to have_content "Approve videos"
  end

  scenario "disapprove video" do
    admin = create :user, admin: true
    video = create :video, approved: false

    visit root_path(as: admin)

    click_link "Approve videos"
    click_button "Disapprove"

    expect(page).not_to have_content video.name
  end

  scenario "the user gets a notification" do
    admin = create :user, admin: true
    video = create :video, approved: false

    visit root_path(as: admin)

    click_link "Approve videos"
    click_button "Approve"

    visit root_path(as: video.user)

    expect(page).to have_content "Notifications (1)"
  end
end
