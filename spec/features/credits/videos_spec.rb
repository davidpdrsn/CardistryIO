require "rails_helper"

feature "adding credits to video" do
  # scenario "all good", :js do
  #   user = create :user, username: "davidpdrsn"
  #   visit new_video_path(as: user)
  #   fill_in "Name", with: "Classic"
  #   fill_in "URL", with: "https://www.youtube.com/watch?v=W799NKLEz8s"
  #   fill_in "Description", with: "A video I made"
  #   select "Performance", from: "Type"
  #   within ".add-credits" do
  #     fill_in "Username", with: "david"
  #     click_link "@davidpdrsn"
  #   end
  #   click_button "Submit video"

  #   admin = create :user, admin: true
  #   visit root_path(as: admin)
  #   click_link "Approve videos"
  #   click_button "Approve"

  #   visit root_path(as: user)
  #   click_link "Videos"
  #   click_link "Classic"

  #   expect(page).to have_content "Classic"
  #   within ".credits" do
  #     expect(page).to have_content "@davidpdrsn"
  #   end
  # end

  # scenario "editing the credits", :js do
  #   user = create :user, username: "davidpdrsn"
  #   create :user, username: "bob"
  #   visit new_video_path(as: user)
  #   fill_in "Name", with: "Classic"
  #   fill_in "URL", with: "https://www.youtube.com/watch?v=W799NKLEz8s"
  #   fill_in "Description", with: "A video I made"
  #   select "Performance", from: "Type"
  #   within ".add-credits" do
  #     fill_in "Username", with: "david"
  #     click_link "@davidpdrsn"
  #   end
  #   click_button "Submit video"

  #   admin = create :user, admin: true
  #   visit root_path(as: admin)
  #   click_link "Approve videos"
  #   click_button "Approve"

  #   visit root_path(as: user)
  #   click_link "Videos"
  #   click_link "Classic"
  #   click_button "Edit"

  #   within ".add-credits" do
  #     click_button "Remove"
  #     fill_in "Username", with: "bob"
  #     click_link "@bob"
  #   end
  #   click_button "Update video"

  #   within ".credits" do
  #     expect(page).to have_content "@bob"
  #     expect(page).not_to have_content "@davidpdrsn"
  #   end
  # end
end
