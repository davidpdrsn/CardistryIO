require "rails_helper"

feature "making comments" do
  context "on moves" do
    scenario "valid comment" do
      text = "Really awesome dude"
      move = create :move

      visit move_path(move, as: user)
      within ".add_comment" do
        click_button "Add comment"
        fill_in "Content", with: text
        click_button "Submit comment"
      end

      expect(page).to have_css(".comments", text: text)
    end

    scenario "invalid comment" do
      move = create :move

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

      expect(page).to have_css(".comment", text: user.username)
    end

    scenario "doesn't show form if not logged in" do
      comment = create :comment
      move = comment.commentable

      visit move_path(move)

      expect(page).to_not have_css(".add_comment_form")
    end

    scenario "editing comments" do
      comment = create :comment, content: "Old text"
      move = comment.commentable

      visit move_path(move, as: comment.user)
      within ".comments" do
        click_link "Edit"
      end
      fill_in "Content", with: "new text"
      click_button "Update Comment"

      expect(page).to have_css(".comment", text: "new text")
    end

    scenario "can't edit other users comments" do
      comment = create :comment
      move = comment.commentable

      visit move_path(move)

      expect(page).not_to have_content "Edit"
    end

    scenario "shows when the comment was last updated" do
      comment = create :comment
      comment.update!(content: "hi!")
      move = comment.commentable

      visit move_path(move, as: move.user)

      expect(page).to have_content "Updated"
    end

    scenario "doesn't show a time stamp for comments that aren't updated" do
      comment = create :comment
      move = comment.commentable

      visit move_path(move, as: move.user)

      expect(page).not_to have_content "Updated"
    end
  end

  context "on videos" do
    # So much of the code is shared that more testing shouldn't be necessary

    scenario "valid comment" do
      text = "Really awesome dude"
      video = create :video

      visit video_path(video, as: user)
      within ".add_comment" do
        click_button "Add comment"
        fill_in "Content", with: text
        click_button "Submit comment"
      end

      expect(page).to have_css(".comments", text: text)
    end
  end

  let(:user) { create :user }
end
