require "rails_helper"

feature "tracking views on videos" do
  scenario "sees stats about views" do
    bob = create :user
    alice = create :user
    video = create :video, user: bob

    2.times do
      visit video_path(video, as: alice)
    end

    expect(page).to_not have_content "Stats"

    visit video_path(video, as: bob)

    expect(page).to have_content "Stats"
    expect(page).to have_content "2 views"
    expect(page).to have_content "1 unique view"
  end
end
