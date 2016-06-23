require "rails_helper"

feature "viewing videos" do
  scenario "viewing users videos" do
    user = create :user
    create :video, user: user, name: "Classic", approved: true
    create :video, user: user, name: "Air Time", approved: false
    create :video, name: "Cardistry Con", approved: true

    visit root_path(as: user)

    click_link "My Videos"

    expect(page).to have_content "Classic"
    expect(page).not_to have_content "Cardistry Con"
    expect(page).not_to have_content "Air Time"
  end

  scenario "sees all approved videos" do
    video = create :video, name: "Classic", approved: true
    create :video, name: "Cardistry Con", approved: true

    visit root_path
    click_link "All Videos"

    expect(page).to have_content "Classic"
    expect(page).to have_content "Cardistry Con"
  end

  scenario "doesn't see unapproved videos" do
    video = create :video, approved: false

    visit root_path
    click_link "My Videos"

    expect(page).not_to have_content video.name
  end
end
