require "rails_helper"

feature "shows video views on user profile" do
  scenario "sees video views" do
    user = create :user
    video = create :video, user: user
    4.times { create :video_view, user: user, video: video }

    visit user_path(user, as: user)

    expect(page).to have_content "#{video.reload.views.count} views"
  end
end
