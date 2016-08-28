require "rails_helper"

feature "filtering and sorting videos" do
  include OrderExpectations

  scenario "filtering for tutorials", :js do
    tutorial = create :video, video_type: :tutorial
    performance = create :video, video_type: :performance

    visit all_videos_path
    select "Show only tutorials", from: "filter_type"

    expect(page).to have_content tutorial.name
    expect(page).to_not have_content performance.name
  end

  scenario "sorting by created at by default" do
    one = create :video, created_at: Time.zone.now
    two = create :video, created_at: 2.days.ago
    three = create :video, created_at: 2.weeks.ago

    visit all_videos_path

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by created at ascending", :js do
    one = create :video, created_at: Time.zone.now
    two = create :video, created_at: 2.days.ago
    three = create :video, created_at: 10.weeks.ago

    visit all_videos_path
    select "Ascending", from: "sort_direction"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end

  scenario "sorting by rating", :js do
    one = create :video, created_at: Time.zone.now
    5.times { create :rating, rateable: one, rating: 5 }

    two = create :video, created_at: 2.days.ago
    5.times { create :rating, rateable: two, rating: 3 }

    three = create :video, created_at: 10.weeks.ago
    5.times { create :rating, rateable: three, rating: 1 }

    visit all_videos_path
    select "Sort by rating", from: "sort_by"
    select "Descending", from: "sort_direction"

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by rating in reverse", :js do
    one = create :video, created_at: Time.zone.now
    5.times { create :rating, rateable: one, rating: 5 }

    two = create :video, created_at: 2.days.ago
    5.times { create :rating, rateable: two, rating: 3 }

    three = create :video, created_at: 10.weeks.ago
    5.times { create :rating, rateable: three, rating: 1 }

    visit all_videos_path
    select "Sort by rating", from: "sort_by"
    select "Ascending", from: "sort_direction"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end

  scenario "sorting by number of views", :js do
    user = create :user

    one = create :video, name: "one"
    13.times { create :video_view, video: one, user: user }

    two = create :video, name: "two"
    12.times { create :video_view, video: two, user: user }

    three = create :video, name: "three"
    11.times { create :video_view, video: three, user: user }

    visit all_videos_path
    select "Sort by views", from: "sort_by"
    select "Descending", from: "sort_direction"

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "filtering and sorting of 'My Videos'", :js do
    bob = create :user
    tutorial = create :video, video_type: :tutorial, user: bob, created_at: Time.zone.now
    old_tutorial = create :video, video_type: :tutorial, user: bob, created_at: 2.weeks.ago
    performance = create :video, video_type: :performance, user: bob
    other_users_video = create :video, video_type: :tutorial

    visit root_path(as: bob)
    click_link "My Videos"
    select "Show only tutorials", from: "filter_type"
    select "Ascending", from: "sort_direction"

    expect(page).to_not have_content performance.name
    expect(page).to_not have_content other_users_video.name
    expect_to_appear_in_order([old_tutorial, tutorial].map(&:name))
  end
end
