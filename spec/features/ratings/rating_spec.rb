require "rails_helper"

feature "rating move" do
  context "move" do
    scenario "rating move" do
      bob = create :user
      move = create :move

      visit move_path(move, as: bob)
      click_button "5/5: Inhuman"

      expect(page).to have_content "Average rating: 5.0"
      expect(page).to have_content "Total ratings: 1"
    end

    scenario "cannot rate own moves" do
      bob = create :user
      move = create :move, user: bob

      visit move_path(move, as: bob)

      expect(page).not_to have_button "5/5: Inhuman"
    end
  end

  context "video" do
    scenario "rating video" do
      bob = create :user
      video = create :video, approved: true

      visit video_path(video, as: bob)
      click_button "5/5: Inhuman"

      expect(page).to have_content "Average rating: 5.0"
      expect(page).to have_content "Total ratings: 1"
    end
  end

  scenario "cannot rate when not logged in" do
    video = create :video, approved: true

    visit video_path(video)

    expect(page).not_to have_button "5/5: Inhuman"
  end

  scenario "can't vote more than once" do
    bob = create :user
    video = create :video, approved: true

    visit video_path(video, as: bob)
    click_button "5/5: Inhuman"
    visit video_path(video, as: bob)

    expect(page).not_to have_button "5/5: Inhuman"
  end
end
