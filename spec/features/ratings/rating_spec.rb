require "rails_helper"

feature "rating move" do
  context "move" do
    scenario "rating move", :js do
      bob = create :user
      move = create :move

      visit move_path(move, as: bob)
      find("#rate-5").click
      wait_for_ajax

      expect(page).to have_content "Rating counted"
    end

    scenario "cannot rate own moves" do
      bob = create :user
      move = create :move, user: bob

      visit move_path(move, as: bob)

      expect(page).not_to have_selector(:css, "#vote-5")
    end
  end

  context "video" do
    scenario "rating video", :js do
      bob = create :user
      video = create :video, approved: true

      visit video_path(video, as: bob)
      find("#rate-5").click
      wait_for_ajax

      expect(page).to have_content "Rating counted"
    end
  end

  scenario "cannot rate when not logged in" do
    video = create :video, approved: true

    visit video_path(video)

    expect(page).not_to have_selector(:css, "#vote-5")
  end

  scenario "can't vote more than once" do
    bob = create :user
    video = create :video, approved: true

    visit video_path(video, as: bob)
    find("#rate-5").click
    visit video_path(video, as: bob)

    expect(page).not_to have_selector(:css, "#vote-5")
  end

  scenario "trying to rate when not signed in" do
    move = create :move

    visit move_path(move)

    expect(page).to_not have_content "You can't rate your own moves."
    expect(page).to have_content "Sign in to rate"
  end
end
