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

    expect(page).to have_content "New comment on #{video.name} by @#{alice.username}"
  end

  scenario "marking all notifications as seen" do
    bob = create :user
    create :notification, user: bob

    visit root_path(as: bob)
    click_link "Mark all as read"
    visit root_path(as: bob)

    expect(page).to have_content "0 new notifications"
  end

  scenario "can't mark all read when there are none" do
    bob = create :user

    visit root_path(as: bob)

    expect(page).not_to have_link "Mark all as read"
  end

  scenario "visiting the subject for a notification" do
    bob = create :user
    video = create :video
    comment = create :comment, commentable: video
    notification = create(
      :notification,
      user: bob,
      subject: comment,
      notification_type: :comment,
    )

    visit root_path(as: bob)
    click_link notification.text.expand

    expect(page.current_path).to eq video_path(video)
  end
end
