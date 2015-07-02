require "rails_helper"

feature "making comments" do
  context "on moves" do
    scenario "valid comment" do
      text = "Really awesome dude"
      move = create :move, user: user

      visit move_path(move, as: user)
      within ".add_comment" do
        click_button "Add comment"
        fill_in "Content", with: text
        click_button "Submit comment"
      end

      expect(page).to have_css(".comments", text: text)
    end

    scenario "invalid comment" do
      move = create :move, user: user

      visit move_path(move, as: user)
      within ".add_comment" do
        click_button "Add comment"
        fill_in "Content", with: ""
        click_button "Submit comment"
      end

      expect(page).to have_css(".flash-alert")
    end

    scenario "shows the user" do
      comment = create :comment, user: user
      move = comment.commentable

      visit move_path(move, as: user)

      expect(page).to have_css(".comment", text: user.first_name)
    end

    scenario "doesn't show form if not logged in" do
      comment = create :comment
      move = comment.commentable

      visit move_path(move)

      expect(page).to_not have_css(".add_comment_form")
    end
  end

  let(:user) { create :user }
end
