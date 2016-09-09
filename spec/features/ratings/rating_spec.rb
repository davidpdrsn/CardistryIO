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

  context "cannot rate text" do
    scenario "not signed in" do
      move = create :move

      visit move_path(move)

      expect(page).not_to have_selector(:css, "#vote-5")
      expect(page).to_not have_content "You can't rate your own moves."
      expect(page).to have_content "Sign in to rate"
    end

    scenario "rated already" do
      bob = create :user
      video = create :video, approved: true

      create :rating, rateable: video, user: bob

      visit video_path(video, as: bob)

      expect(page).not_to have_selector(:css, "#vote-5")
      expect(page).to have_content "Rating counted"
    end

    scenario "rating own thing" do
      bob = create :user
      move = create :move, user: bob

      visit move_path(move, as: bob)

      expect(page).not_to have_selector(:css, "#vote-5")
      expect(page).to have_content "You can't rate your own moves"
    end
  end
end
