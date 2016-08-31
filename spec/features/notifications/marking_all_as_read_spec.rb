require "rails_helper"

feature "marking all notifications as read" do
  scenario "only shows the unread ones" do
    huron = create :user, username: "huron"
    daren = create :user, username: "daren"
    josh = create :user, username: "josh"

    visit user_path(huron, as: daren)
    click_link "Follow"

    visit root_path(as: huron)
    click_link "Mark all as read"

    visit user_path(huron, as: josh)
    click_link "Follow"

    visit root_path(as: huron)

    expect(page).to_not have_content "daren started following you"
    expect(page).to have_content "josh started following you"
  end

  it "keeps you on the page were on" do
    huron = create :user, username: "huron"
    daren = create :user, username: "daren"
    josh = create :user, username: "josh"

    visit user_path(huron, as: daren)
    click_link "Follow"

    visit user_path(josh, as: huron)
    click_link "Mark all as read"

    expect(page).to have_content josh.username
  end
end
