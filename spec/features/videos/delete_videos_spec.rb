require "rails_helper"

feature "delete videos" do
  scenario "delete videos" do
    video = create :video
    visit video_path(video, as: video.user)
    click_button "Delete video"
    click_link "My Videos"

    expect(page).not_to have_content video.name
  end

  scenario "can't delete unowned videos" do
    video = create :video
    visit video_path(video, as: create(:user))

    expect(page).not_to have_button "Delete video"
  end
end
