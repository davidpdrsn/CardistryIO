require "rails_helper"

feature "notifications when approving videos" do
  scenario "the user gets a notification" do
    admin = create :user, admin: true
    video = create :video, approved: false, name: "Classic"

    visit root_path(as: admin)

    click_link "Approve videos"
    click_button "Approve"

    visit root_path(as: video.user)

    expect(page).to have_content "Your video Classic has been approved"
  end
end
