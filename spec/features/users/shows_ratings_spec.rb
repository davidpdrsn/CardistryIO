require "rails_helper"

feature "shows ratings" do
  scenario "sees ratings for videos" do
    user = create :user
    video = create :video, user: user
    create :rating, user: create(:user), rateable: video, rating: 5
    create :rating, user: create(:user), rateable: video, rating: 2

    visit user_path(user, as: user)

    rating_starts = page.body.scan(/ion-android-star/)
    expect(rating_starts.count).to eq (5 + 2).fdiv(2).round
  end

  scenario "sees no ratings yet for videos" do
    user = create :user
    video = create :video, user: user

    visit user_path(user, as: user)

    expect(page).to have_content t("ratings.not_rated")
  end

  scenario "sees ratings for moves" do
    user = create :user
    move = create :move, user: user
    create :rating, user: create(:user), rateable: move, rating: 5
    create :rating, user: create(:user), rateable: move, rating: 2

    visit user_path(user, as: user)

    rating_starts = page.body.scan(/ion-android-star/)
    expect(rating_starts.count).to eq (5 + 2).fdiv(2).round
  end

  scenario "sees no ratings yet for moves" do
    user = create :user
    move = create :move, user: user

    visit user_path(user, as: user)

    expect(page).to have_content t("ratings.not_rated")
  end
end
