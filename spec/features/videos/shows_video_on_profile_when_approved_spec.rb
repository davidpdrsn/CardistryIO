require "rails_helper"

feature "shows video on profile when approved" do
  scenario "sees the video on profile" do
    admin = create :user, admin: true
    video = create :video, approved: false

    visit user_path(video.user, as: admin)

    expect(page).not_to have_content video.name

    click_link "Approve videos"
    click_button "Approve"

    visit user_path(video.user, as: admin)
    expect(page).to have_content video.name
  end

  scenario "doesn't show private videos on profile" do
    admin = create :user, admin: true
    video = create :video, approved: true, private: true

    visit user_path(video.user, as: admin)

    expect(page).not_to have_content video.name

    video.update!(private: false)

    visit user_path(video.user, as: admin)
    expect(page).to have_content video.name
  end
end
