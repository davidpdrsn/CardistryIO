require "rails_helper"

feature "filtering moves spec" do
  scenario "shows all by default" do
    move = create :move, idea: false
    idea = create :move, idea: true

    visit all_moves_path

    expect(page).to have_content move.name
    expect(page).to have_content idea.name
  end

  scenario "filtering by idea" do
    move = create :move, idea: false
    idea = create :move, idea: true

    visit all_moves_path
    select "Ideas", from: "filter_type"
    click_button "Go"

    expect(page).to_not have_content move.name
    expect(page).to have_content idea.name
  end

  scenario "filtering by moves" do
    move = create :move, idea: false
    idea = create :move, idea: true

    visit all_moves_path
    # TODO: Come up with a better name for this
    select "Finished", from: "filter_type"
    click_button "Go"

    expect(page).to have_content move.name
    expect(page).to_not have_content idea.name
  end

  scenario "filtering 'My Moves'" do
    user = create :user
    move = create :move, idea: false, user: user
    idea = create :move, idea: true, user: user

    visit moves_path(as: user)
    # TODO: Come up with a better name for this
    select "Finished", from: "filter_type"
    click_button "Go"

    expect(page).to have_content move.name
    expect(page).to_not have_content idea.name
  end
end
