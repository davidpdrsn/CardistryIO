require "rails_helper"

feature "appearances" do
  let(:user) { create :user }

  scenario "making a video contain move appearances" do
    move = create :move, user: user
    video = create :video, user: user

    visit root_path(as: user)
    click_link "My videos"
    click_link video.name
    click_link "Edit move appearances"
    fill_in "Move name", with: move.name
    fill_in "Minutes", with: "1"
    fill_in "Seconds", with: "23"
    click_button "Submit"

    expect(page).to have_content "Moves in this video"
    expect(page).to have_content move.name
    expect(page).to have_content "01:23"
  end

  scenario "shows current appearances" do
    move = create :move, user: user
    video = create :video, user: user
    create :appearance, video: video, move: move, minutes: 1, seconds: 1

    visit root_path(as: user)
    click_link "My videos"
    click_link video.name
    click_link "Edit move appearances"

    expect(page).to have_css "input.move-name[value='#{move.name}']"
  end

  scenario "search as you type for moves"

  scenario "remove all video appearances"

  scenario "show video on edit page, as reference"

  scenario "specifying that a move appears in a video"

  scenario "can only edit move appearances if owns the video" do
    move = create :move, user: user
    video = create :video, user: user

    visit video_path(video)

    expect(page).not_to have_content "Edit move appearances"
  end
end
