require "rails_helper"

feature "delete moves" do
  scenario "delete moves" do
    user = create :user
    move = create :move, user: user

    visit move_path(move, as: user)
    click_button "Delete"
    click_link "My moves"

    expect(page).not_to have_content move.name
  end

  scenario "can't delete other users moves" do
    user = create :user
    move = create :move

    visit move_path(move, as: user)

    expect(page).not_to have_button "Delete"
  end
end
