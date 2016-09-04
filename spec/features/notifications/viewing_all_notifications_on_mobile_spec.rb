require "rails_helper"

feature "viewing all notifications on mobile" do
  scenario "interacts with a bunch of notifications" do
    huron = create :user, username: "huron"
    daren = create :user, username: "daren"

    follow_and_notify(huron, as: daren)
    visit notifications_path(as: huron)

    expect(Notification.count).to eq 1
    within ".content-area" do
      expect(page).to have_content(Notification.last.expanded_text)

      click_link "Mark all as read"
    end
    visit notifications_path(as: huron)

    within ".content-area" do
      expect(page).to_not have_content(Notification.last.expanded_text)
      expect(page).to_not have_link "Mark all as read"
    end

    kevin = create :user, username: "kevin"
    follow_and_notify(huron, as: kevin)
    visit notifications_path(as: huron)
    within ".content-area" do
      click_link Notification.last.expanded_text
    end
    expect(page.current_path).to eq user_path(kevin)
    visit notifications_path(as: huron)
    expect(page).to have_content "You have no new notifications"
  end

  def follow_and_notify(followee, as:)
    follower = as
    visit user_path(followee, as: follower)
    click_link "Follow"
  end
end
