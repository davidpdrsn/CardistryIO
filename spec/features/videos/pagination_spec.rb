require "rails_helper"

feature "paginating videos" do
  scenario "paging" do
    videos = 25.times.map do
      create :video
    end

    visit all_videos_path

    expect(page).to have_content videos.last.name
    expect(page).to_not have_content videos.first.name

    find("#pagination-forward").click

    expect(page).to have_content videos.first.name
    expect(page).to_not have_content videos.last.name

    find("#pagination-back").click

    expect(page).to have_content videos.last.name
    expect(page).to_not have_content videos.first.name
  end

  scenario "paging far" do
    videos = 45.times.map do
      create :video
    end

    visit all_videos_path
    find("#pagination-forward").click
    find("#pagination-forward").click

    expect(page).to have_content videos.first.name
  end

  scenario "no previous page on first page" do
    create :video

    visit all_videos_path

    expect(page).to have_selector(:css, "#pagination-back")
    expect(page).to have_selector(:css, ".pagination-nav-button .back .disabled")
  end

  scenario "no next page on last page" do
    create :video

    visit all_videos_path

    expect(page).to have_selector(:css, "#pagination-forward")
    expect(page).to have_selector(:css, ".pagination-nav-button .forward .disabled")
  end

  scenario "sees no paging buttons when there are few videos" do
    visit all_videos_path

    expect(page).to_not have_content "Next"
    expect(page).to_not have_content "Prev"
  end

  scenario "paging 'My Videos'" do
    user = create :user
    videos = 25.times.map do
      create :video, user: user
    end

    visit videos_path(as: user)

    expect(page).to have_content videos.last.name
    expect(page).to_not have_content videos.first.name

    find("#pagination-forward").click

    expect(page).to have_content videos.first.name
    expect(page).to_not have_content videos.last.name

    find("#pagination-back").click

    expect(page).to have_content videos.last.name
    expect(page).to_not have_content videos.first.name
  end
end
