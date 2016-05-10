require "rails_helper"

feature "setting and applying time zone spec" do
  scenario "sees the right time zone" do
    video = create :video
    user = video.user

    visit user_path(user, as: user)
    expect(page).not_to have_content("Hawaii")

    visit edit_user_path(user, as: user)
    select "Hawaii", from: "Time zone"
    click_button "Update User"

    visit user_path(user, as: user)
    expect(page).to have_content("Hawaii")
  end
end
