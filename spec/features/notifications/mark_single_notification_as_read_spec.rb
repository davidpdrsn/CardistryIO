require "rails_helper"

feature "marking single notification as read" do
  scenario "marks single notification as read" do
    huron = create :user, username: "huron"
    daren = create :user, username: "daren", biography: "I like cards"

    visit user_path(huron, as: daren)
    click_link "Follow"
    visit root_path(as: huron)
    click_link Notification.last.text

    expect(page).to have_content daren.biography
    expect(huron.new_notifications.count).to eq 0
    expect(page).to_not have_content "Mark all as read"
  end
end
