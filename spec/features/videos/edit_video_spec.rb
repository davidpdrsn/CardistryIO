require "rails_helper"

feature "edit video" do
  scenario "edit video" do
    video = create :video, name: "Mocking Bird", description: "hi there"

    visit video_path(video, as: video.user)
    click_button "Edit"
    fill_in "Name", with: "Sybil"
    fill_in "Description", with: "stuff goes here"
    click_button "Update video"

    expect(page).to have_content "Sybil"
    expect(page).to have_content "stuff goes here"
  end

  scenario "doesn't see edit link if not owns video" do
    video = create :video

    visit video_path(video, as: create(:user))

    expect(page).not_to have_content "Edit"
  end
end
