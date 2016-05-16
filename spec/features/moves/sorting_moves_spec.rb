require "rails_helper"

feature "sorting moves" do
  include OrderExpectations

  scenario "sorts by created at desc by default" do
    one = create :move, created_at: Time.zone.now
    two = create :move, created_at: 1.day.ago
    three = create :move, created_at: 3.weeks.ago

    visit all_moves_path

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by created at desc" do
    one = create :move, created_at: Time.zone.now
    two = create :move, created_at: 1.day.ago
    three = create :move, created_at: 3.weeks.ago

    visit all_moves_path
    select "Date", from: "sort_by"
    select "Highest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by created at acs" do
    one = create :move, created_at: Time.zone.now
    two = create :move, created_at: 1.day.ago
    three = create :move, created_at: 3.weeks.ago

    visit all_moves_path
    select "Date", from: "sort_by"
    select "Lowest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end

  scenario "sorting by rating desc" do
    one = create :move, created_at: Time.zone.now
    5.times { create :rating, rateable: one, rating: 5 }

    two = create :move, created_at: 2.days.ago
    5.times { create :rating, rateable: two, rating: 3 }

    three = create :move, created_at: 10.weeks.ago
    5.times { create :rating, rateable: three, rating: 1 }

    visit all_moves_path
    select "Rating", from: "sort_by"
    select "Highest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by rating asc" do
    one = create :move, created_at: Time.zone.now
    5.times { create :rating, rateable: one, rating: 1 }

    two = create :move, created_at: 2.days.ago
    5.times { create :rating, rateable: two, rating: 3 }

    three = create :move, created_at: 10.weeks.ago
    5.times { create :rating, rateable: three, rating: 5 }

    visit all_moves_path
    select "Rating", from: "sort_by"
    select "Highest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end

  scenario "sorting 'My Moves'" do
    user = create :user

    one = create :move, created_at: Time.zone.now, user: user
    5.times { create :rating, rateable: one, rating: 1 }

    two = create :move, created_at: 2.days.ago, user: user
    5.times { create :rating, rateable: two, rating: 3 }

    three = create :move, created_at: 10.weeks.ago, user: user
    5.times { create :rating, rateable: three, rating: 5 }

    visit moves_path(as: user)
    select "Rating", from: "sort_by"
    select "Highest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end
end
