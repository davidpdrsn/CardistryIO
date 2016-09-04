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

    scenario "can't edit other users comments" do
      comment = create :comment
      move = comment.commentable

      visit move_path(move)

      expect(page).not_to have_content "Edit"
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

  include OrderExpectations

  scenario "shows in the right order on moves" do
    move = create :move
    one = create :comment, commentable: move, content: "one", created_at: 3.days.ago
    two = create :comment, commentable: move, content: "two", created_at: 2.days.ago
    three = create :comment, commentable: move, content: "three", created_at: 1.day.ago

    visit move_path(move)

    expect_to_appear_in_order([one, two, three].map(&:content))
  end

  scenario "shows in the right order on videos" do
    video = create :video
    one = create :comment, commentable: video, content: "one", created_at: 3.days.ago
    two = create :comment, commentable: video, content: "two", created_at: 2.days.ago
    three = create :comment, commentable: video, content: "three", created_at: 1.day.ago

    visit video_path(video)

    expect_to_appear_in_order([one, two, three].map(&:content))
  end

  let(:user) { create :user }
end
