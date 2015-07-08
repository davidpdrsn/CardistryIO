require "rails_helper"

feature "notifications from comments" do
  scenario "receives notifications" do
    bob = create :user
    video = create :video, user: bob
    alice = create :user

    visit video_path(video, as: alice)
    click_button "Add comment"
    fill_in "Content", with: "Awesome!"
    click_button "Submit comment"

    visit root_path(as: bob)
    click_link "Notifications (1)"

    expect(page).to have_content "New comment on #{video.name} by @#{alice.username}"
  end

  scenario "marking all notifications as seen" do
    bob = create :user
    create :notification, user: bob

    visit notifications_path(as: bob)
    click_button "Mark all read"
    visit root_path(as: bob)
    click_link "Notifications (0)"

    expect(page).to have_content "You have no notifications"
  end

  scenario "can't mark all read when there are none" do
    bob = create :user

    visit notifications_path(as: bob)

    expect(page).not_to have_button "Mark all read"
  end
end
