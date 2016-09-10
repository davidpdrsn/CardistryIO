require "rails_helper"

feature "featuring videos" do
  scenario "normal users cannot feature" do
    video = create :video
    huron = create :user, username: "huron"

    visit video_path(video, as: huron)

    expect(page).to_not have_content "Feature video"
  end

  scenario "admin users can feature videos", :js do
    video = create :video
    another_video = create :video
    huron = create :user, username: "huron", admin: true

    visit video_path(video, as: huron)
    click_link "Feature video"
    click_link "All Videos"
    select "Show only featured videos", from: :filter_type

    expect(page).to have_content video.name
    expect(page).to_not have_content another_video.name
  end

  scenario "admin unfeatures a video", :js do
    video = create :video
    huron = create :user, username: "huron", admin: true

    visit video_path(video, as: huron)
    click_link "Feature video"
    click_link "Unfeature video"
    click_link "All Videos"
    select "Show only featured videos", from: :filter_type

    expect(page).to_not have_content video.name
  end

  scenario "notifies the user who made the video" do
    huron = create :user, username: "huron", admin: true
    daren = create :user, username: "daren"
    video = create :video, user: daren

    visit video_path(video, as: huron)
    click_link "Feature video"
    visit notifications_path(as: daren)

    within ".content-area" do
      click_link "Your video #{video.name} has been featured"
    end

    expect(page.current_path).to eq video_path(video)
  end

  scenario "shows featured videos on 'All Videos'" do
    video = create :video
    video.feature!
    admin = create :user, admin: true

    visit videos_path(as: admin)

    within ".featured-videos" do
      expect(page).to have_content video.name
    end
  end

  scenario "doesn't see featured videos as non admin" do
    video = create :video
    video.feature!
    user = create :user, admin: false

    visit videos_path(as: user)

    expect(page).to have_css(".featured-videos")
  end
end
