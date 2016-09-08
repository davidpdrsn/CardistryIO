require "rails_helper"

feature "getting notified when mentioned" do
  scenario "on comments" do
    alice = create :user, username: "alice"
    bob = create :user, username: "bob"
    video = create :video

    visit video_path(video, as: bob)
    within ".add_comment" do
      click_button "Add comment"
      fill_in "Content", with: "@#{alice.username} should check this out!"
      click_button "Submit comment"
    end

    visit root_path(as: alice)
    expect(page).to have_content "1 new notification"

    expect(page).to have_content "@#{bob.username} mentioned you in a comment"

    find("a", text: /mentioned you in a/).click

    expect(page).to have_content video.name
  end

  scenario "doesn't notify when mentioning self" do
    alice = create :user, username: "alice"
    bob = create :user, username: "bob"
    video = create :video

    visit video_path(video, as: bob)
    within ".add_comment" do
      click_button "Add comment"
      fill_in "Content", with: "@#{bob.username} should check this out!"
      click_button "Submit comment"
    end

    visit root_path(as: bob)
    expect(page).to have_content "0 new notifications"
  end

  scenario "in moves" do
    bob = create :user, username: "bob"
    alice = create :user, username: "alice"
    visit root_path(as: bob)
    within "header .button-bar" do
      click_link "Move"
    end
    fill_in "Title", with: "Sybil"
    fill_in "Description", with: "This one is for you @#{alice.username} <3"
    click_button "Add move"

    visit root_path(as: alice)
    expect(page).to have_content "@#{bob.username} mentioned you in a move"

    find("a", text: /mentioned you in a/).click

    expect(page).to have_content "Sybil"
  end

  scenario "in videos" do
    bob = create :user, username: "bob"
    alice = create :user, username: "alice"
    visit root_path(as: bob)
    within "header .button-bar" do
      click_link "Video"
    end
    fill_in "Title", with: "Classic"
    fill_in "URL", with: "https://www.youtube.com/watch?v=W799NKLEz8s"
    fill_in "Description", with: "@#{alice.username} hi there"
    select "Performance", from: "Type"
    click_button "Submit video"

    approve_video

    visit root_path(as: alice)

    expect(page).to have_content "@#{bob.username} mentioned you in a video"

    find("a", text: /mentioned you in a/).click

    expect(page).to have_content "Classic"
  end

  def approve_video
    admin = create :user, admin: true
    visit root_path(as: admin)
    click_link "Approve videos"
    click_button "Approve"
  end
end
