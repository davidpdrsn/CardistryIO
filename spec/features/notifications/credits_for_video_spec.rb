require "rails_helper"

feature "credits when adding video" do
  # scenario "adding video", :js do
  #   user = create :user
  #   bob = create :user, username: "bob"
  #   visit new_video_path(as: user)
  #   fill_in "Name", with: "Classic"
  #   fill_in "URL", with: "https://www.youtube.com/watch?v=W799NKLEz8s"
  #   fill_in "Description", with: "A video I made"
  #   select "Performance", from: "Type"
  #   within ".add-credits" do
  #     fill_in "Username", with: "bob"
  #     click_link "@bob"
  #   end
  #   click_button "Submit video"

  #   admin = create :user, admin: true
  #   visit root_path(as: admin)
  #   click_link "Approve videos"
  #   click_button "Approve"

  #   visit notifications_path(as: bob)

  #   expect(page).to have_content "@#{user.username} credited you for his video"

  #   click_link "video"
  #   expect(page).to have_content "Classic"
  # end

  # scenario "updating video", :js do
  #   bob = create :user, username: "bob"
  #   video = create :video
  #   video.credits.create(user: create(:user))
  #   visit edit_video_path(video, as: video.user)
  #   within ".add-credits" do
  #     click_button "Remove"
  #     fill_in "Username", with: "bob"
  #     click_link "@bob"
  #   end
  #   click_button "Update video"

  #   visit notifications_path(as: bob)

  #   expect(page).to have_content "@#{video.user.username} credited you for his video"

  #   click_link "video"
  #   expect(page).to have_content video.name
  # end
end
