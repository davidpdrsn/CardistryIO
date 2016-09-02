require "rails_helper"

feature "viewing video from another user spec" do
  scenario "sees the video" do
    bob = create :user, username: "bob"
    alice = create :user, username: "alice"
    video = Video.create!(
      name: "Waterwheel",
      description: "I like this move",
      url: "https://scontent.cdninstagram.com/t50.2886-16/10622677_448166048705482_1533639153_s.mp4",
      user: bob,
      approved: true,
      private: false,
      instagram_id: "1184776464917987209_962942",
      video_type: "move_showcase",
    )
    Observers::HaltUnlessPublic.new(Observers::CreatesActivities.new).save(video)

    alice.follow!(bob)
    visit root_path(as: alice)
    click_link video.name

    expect(page).to have_content video.name
  end
end
