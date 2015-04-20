require "rails_helper"

feature "viewing videos" do
  scenario "viewing users videos" do
    user = create :user
    video = create :video, user: user, name: "Classic"
    create :video, name: "Cardistry Con"

    visit root_path(as: user)
    click_link "My videos"

    expect(page).to have_content "Classic"
    expect(page).not_to have_content "Cardistry Con"
  end

  scenario "viewing all videos" do
    video = create :video, name: "Classic"
    create :video, name: "Cardistry Con"

    visit root_path
    click_link "All videos"

    expect(page).to have_content "Classic"
    expect(page).to have_content "Cardistry Con"
  end
end
