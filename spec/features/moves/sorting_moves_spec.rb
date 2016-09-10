require "rails_helper"

feature "sorting moves" do
  include OrderExpectations

  scenario "sorts by created at desc by default" do
    one = create :move, created_at: Time.zone.now
    two = create :move, created_at: 1.day.ago
    three = create :move, created_at: 3.weeks.ago

    visit moves_path

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by created at desc", :js do
    one = create :move, created_at: Time.zone.now
    two = create :move, created_at: 1.day.ago
    three = create :move, created_at: 3.weeks.ago

    visit moves_path
    select "Sort by date", from: "sort_by"
    select "Descending", from: "sort_direction"

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by created at acs", :js do
    one = create :move, created_at: Time.zone.now
    two = create :move, created_at: 1.day.ago
    three = create :move, created_at: 3.weeks.ago

    visit moves_path
    select "Sort by date", from: "sort_by"
    select "Ascending", from: "sort_direction"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end

  scenario "sorting by rating desc", :js do
    highest_rated = create :move, created_at: Time.zone.now, name: "highest_rated"
    5.times { create :rating, rateable: highest_rated, rating: 5 }

    middle_rated = create :move, created_at: 2.days.ago, name: "middle_rated"
    5.times { create :rating, rateable: middle_rated, rating: 3 }

    lowest_rated = create :move, created_at: 10.weeks.ago, name: "lowest_rated"
    5.times { create :rating, rateable: lowest_rated, rating: 1 }

    visit moves_path
    select "Sort by rating", from: "sort_by"
    select "Descending", from: "sort_direction"

    expect_to_appear_in_order([highest_rated,
                               middle_rated,
                               lowest_rated].map(&:name))
  end

  scenario "sorting by rating asc", :js do
    highest_rated = create :move, created_at: Time.zone.now, name: "highest_rated"
    5.times { create :rating, rateable: highest_rated, rating: 5 }

    middle_rated = create :move, created_at: 2.days.ago, name: "middle_rated"
    5.times { create :rating, rateable: middle_rated, rating: 3 }

    lowest_rated = create :move, created_at: 10.weeks.ago, name: "lowest_rated"
    5.times { create :rating, rateable: lowest_rated, rating: 1 }

    visit moves_path
    select "Sort by rating", from: "sort_by"
    select "Ascending", from: "sort_direction"

    expect_to_appear_in_order([lowest_rated,
                               middle_rated,
                               highest_rated].map(&:name))
  end

  scenario "sorting 'My Moves'", :js do
    user = create :user

    one = create :move, created_at: Time.zone.now, user: user
    5.times { create :rating, rateable: one, rating: 1 }

    two = create :move, created_at: 2.days.ago, user: user
    5.times { create :rating, rateable: two, rating: 3 }

    three = create :move, created_at: 10.weeks.ago, user: user
    5.times { create :rating, rateable: three, rating: 5 }

    visit user_moves_path(user, as: user)
    select "Sort by rating", from: "sort_by"
    select "Descending", from: "sort_direction"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end
end
