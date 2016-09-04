require "rails_helper"

feature "featuring videos" do
  scenario "normal users cannot feature" do
    video = create :video
    huron = create :user, username: "huron"

    visit video_path(video, as: huron)

    expect(page).to_not have_content "Feature video"
  end

  scenario "admin users can feature videos" do
    video = create :video
    huron = create :user, username: "huron", admin: true

    visit video_path(video, as: huron)
    click_link "Feature video"
    click_link "Featured videos"

    expect(page).to have_content video.name
  end

  scenario "admin unfeatures a video" do
    video = create :video
    huron = create :user, username: "huron", admin: true

    visit video_path(video, as: huron)
    click_link "Feature video"
    click_link "Unfeature video"
    click_link "Featured videos"

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
end
