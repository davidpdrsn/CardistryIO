require "rails_helper"

feature "private videos" do
  scenario "adding a private video" do
    bob = create :user
    visit root_path(as: bob)
    within ".button-bar" do
      click_link "Video"
    end
    fill_in "Title", with: "Classic"
    fill_in "URL", with: "https://www.youtube.com/watch?v=W799NKLEz8s"
    fill_in "Description", with: "A video I made"
    select "Performance", from: "video_video_type"
    check "Make video private"
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
    select alice.username, from: "User"
    click_button "Share"

    visit root_path(as: alice)
    click_link "Videos shared with you"
    expect(page).to have_content private_video.name
    expect(page).not_to have_content another_private_video.name
  end

  scenario "unsharing video" do
    bob = create :user
    private_video = create :video, user: bob, approved: true, private: true
    alice = create :user
    Sharing.create!(user: alice, video: private_video)

    visit video_path(private_video, as: bob)
    click_link "Edit sharing"
    click_button "Remove"

    visit shared_videos_path(as: alice)
    expect(page).to_not have_content private_video.name
  end

  scenario "can only delete shares, if there are any" do
    bob = create :user
    private_video = create :video, user: bob, approved: true, private: true

    visit video_path(private_video, as: bob)
    expect(page).not_to have_content "Edit sharing"
  end

  scenario "doesn't show private videos on profile" do
    huron = create :user, username: "huron"
    daren = create :user, username: "daren"

    private_video = create :video, user: huron, private: true
    public_video = create :video, user: huron, private: false

    visit user_path(huron, as: daren)

    expect(page).to have_content public_video.name
    expect(page).to_not have_content private_video.name
  end
end
