require "rails_helper"

feature "paginating videos" do
  scenario "paging" do
    videos = 25.times.map do
      create :video
    end

    visit all_videos_path

    expect(page).to have_content videos.first.name
    expect(page).to_not have_content videos.last.name

    click_link "Next"

    expect(page).to_not have_content videos.first.name
    expect(page).to have_content videos.last.name

    click_link "Prev"

    expect(page).to have_content videos.first.name
    expect(page).to_not have_content videos.last.name
  end

  scenario "paging far" do
    videos = 45.times.map do
      create :video
    end

    visit all_videos_path
    click_link "Next"
    click_link "Next"

    expect(page).to have_content videos.last.name
  end

  scenario "no previous page on first page" do
    create :video

    visit all_videos_path

    expect(page).to have_content "Prev"
    expect(page).to_not have_link "Prev"
  end

  scenario "no next page on last page" do
    create :video

    visit all_videos_path

    expect(page).to have_content "Next"
    expect(page).to_not have_link "Next"
  end

  scenario "sees no paging buttons when there are few videos" do
    visit all_videos_path

    expect(page).to_not have_content "Next"
    expect(page).to_not have_content "Prev"
  end
end
