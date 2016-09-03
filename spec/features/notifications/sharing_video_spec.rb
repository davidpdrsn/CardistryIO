require "rails_helper"

feature "notifications when sharing video" do
  scenario "getting notified" do
    bob = create :user
    private_video = create :video, user: bob, approved: true, private: true
    another_private_video = create :video, user: bob, approved: true, private: true
    alice = create :user

    visit video_path(private_video, as: bob)
    click_link "Share video"
    select alice.username, from: "User"
    click_button "Share"

    visit root_path(as: alice)

    expect(page).to have_css("a", text: /shared a video with you/)
  end
end
