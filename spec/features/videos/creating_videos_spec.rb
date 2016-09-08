require "rails_helper"

feature "creating videos" do
  scenario "adding video" do
    user = create :user
    visit root_path(as: user)
    within "header .button-bar" do
      click_link "Video"
    end
    fill_in "Title", with: "Classic"
    fill_in "URL", with: "https://www.youtube.com/watch?v=W799NKLEz8s"
    fill_in "Description", with: "A video I made"
    select "Performance", from: "video_video_type"
    click_button "Submit video"

    admin = create :user, admin: true
    visit root_path(as: admin)
    click_link "Approve videos"
    click_button "Approve"

    visit root_path(as: user)
    click_link "My Videos"
    click_link "Classic"

    expect(page).to have_content "Classic"
    expect(page).to have_content "A video I made"
    expect(page).to have_content "Performance"
  end

  scenario "adding invalid video" do
    user = create :user
    visit root_path(as: user)
    within "header .button-bar" do
      click_link "Video"
    end
    click_button "Submit video"

    expect(page).to have_content "can't be blank"
  end
end
