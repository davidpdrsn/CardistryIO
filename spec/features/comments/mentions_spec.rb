require "rails_helper"

feature "turning mentions into links" do
  scenario "finds the mentions and turns them into links" do
    user = create :user, username: "bob"
    text = "Wow! @bob that was great!"
    move = create :move

    visit move_path(move, as: user)
    within ".add_comment" do
      click_button "Add comment"
      fill_in "Content", with: text
      click_button "Submit comment"
    end

    within ".comments" do
      expect(page).to have_link "@bob"
    end
  end
end
