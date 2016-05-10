require "rails_helper"

feature "approving videos" do
  scenario "admin approves a video" do
    admin = create :user, admin: true
    video = create :video, approved: false

    visit root_path(as: admin)
    click_link "All Videos"

    expect(page).not_to have_content video.name

    click_link "Approve videos"
    click_button "Approve"
    click_link "All Videos"

    expect(page).to have_content video.name
  end

  scenario "shows number of unapproved videos" do
    admin = create :user, admin: true
    video = create :video, approved: false

    visit root_path(as: admin)

    expect(page).to have_link "Approve videos (1)"
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

  scenario "finding mentions" do
    admin = create :user, admin: true
    video = create(
      :video,
      approved: false,
      description: "Thanks to @#{admin.username}",
    )

    visit root_path(as: admin)

    click_link "Approve videos"

    expect(page).to have_link "@#{admin.username}"
  end

  scenario "admin approves a video with having notifications" do
    admin = create :user, admin: true
    create :notification, user: admin
    video = create :video, approved: false

    visit root_path(as: admin)
    click_link "All Videos"

    expect(page).not_to have_content video.name

    click_link "Approve videos"
    click_button "Approve"
    click_link "All Videos"

    expect(page).to have_content video.name
  end
end
