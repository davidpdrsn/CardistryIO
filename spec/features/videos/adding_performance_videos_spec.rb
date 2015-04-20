require "rails_helper"

feature "adding performance videos" do
  scenario "adding video" do
    user = create :user
    visit root_path(as: user)
    click_link "Create video"
    fill_in "Name", with: "Classic"
    fill_in "YouTube URL", with: "https://www.youtube.com/watch?v=W799NKLEz8s"
    fill_in "Description", with: "A video I made"
    click_button "Create Video"

    expect(page).to have_content "Classic"
    expect(page).to have_content "A video I made"
  end

  scenario "adding invalid video" do
    user = create :user
    visit root_path(as: user)
    click_link "Create video"
    click_button "Create Video"

    expect(page).to have_content "can't be blank"
  end
end
