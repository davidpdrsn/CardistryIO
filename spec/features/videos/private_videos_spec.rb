require "rails_helper"

feature "private videos" do
  scenario "adding a private video" do
    bob = create :user
    visit root_path(as: bob)
    click_link "Submit video"
    fill_in "Name", with: "Classic"
    fill_in "YouTube URL", with: "https://www.youtube.com/watch?v=W799NKLEz8s"
    fill_in "Description", with: "A video I made"
    check "Private"
    click_button "Submit video"

    admin = create :user, admin: true
    visit root_path(as: admin)
    click_link "Approve videos"
    click_button "Approve"

    alice = create :user
    visit all_videos_path(as: alice)

    expect(page).not_to have_content "Classic"
  end

  scenario "private videos can be shared with others" do
    bob = create :user
    private_video = create :video, user: bob, approved: true, private: true
    another_private_video = create :video, user: bob, approved: true, private: true
    alice = create :user

    visit video_path(private_video, as: bob)
    click_link "Share video"
    # TODO: Show users avatar is the select
    select alice.email, from: "User"
    click_button "Share"

    visit shared_videos_path(as: alice)
    expect(page).to have_content private_video.name
    expect(page).not_to have_content another_private_video.name
  end
end
