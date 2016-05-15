require "rails_helper"

feature "filtering and sorting videos" do
  scenario "filtering for tutorials" do
    tutorial = create :video, video_type: :tutorial
    performance = create :video, video_type: :performance

    visit all_videos_path
    select "Tutorials", from: "filter_type"
    click_button "Go"

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

  scenario "sorting by created at ascending" do
    one = create :video, created_at: Time.zone.now
    two = create :video, created_at: 2.days.ago
    three = create :video, created_at: 10.weeks.ago

    visit all_videos_path
    select "Lowest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end

  scenario "sorting by rating" do
    one = create :video, created_at: Time.zone.now
    5.times { create :rating, rateable: one, rating: 5 }

    two = create :video, created_at: 2.days.ago
    5.times { create :rating, rateable: two, rating: 3 }

    three = create :video, created_at: 10.weeks.ago
    5.times { create :rating, rateable: three, rating: 1 }

    visit all_videos_path
    select "Rating", from: "sort_by"
    select "Highest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by rating in reverse" do
    one = create :video, created_at: Time.zone.now
    5.times { create :rating, rateable: one, rating: 5 }

    two = create :video, created_at: 2.days.ago
    5.times { create :rating, rateable: two, rating: 3 }

    three = create :video, created_at: 10.weeks.ago
    5.times { create :rating, rateable: three, rating: 1 }

    visit all_videos_path
    select "Rating", from: "sort_by"
    select "Lowest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end

  scenario "sorting by number of views" do
    user = create :user

    one = create :video
    13.times { create :video_view, video: one, user: user }

    two = create :video
    12.times { create :video_view, video: two, user: user }

    three = create :video
    11.times { create :video_view, video: three, user: user }

    visit all_videos_path
    select "Views", from: "sort_by"
    select "Highest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "filtering and sorting of 'My Videos'" do
    bob = create :user
    tutorial = create :video, video_type: :tutorial, user: bob, created_at: Time.zone.now
    old_tutorial = create :video, video_type: :tutorial, user: bob, created_at: 2.weeks.ago
    performance = create :video, video_type: :performance, user: bob
    other_users_video = create :video, video_type: :tutorial

    visit root_path(as: bob)
    click_link "My Videos"
    select "Tutorials", from: "filter_type"
    select "Lowest", from: "sort_direction"
    click_button "Go"

    expect(page).to_not have_content performance.name
    expect(page).to_not have_content other_users_video.name
    expect_to_appear_in_order([old_tutorial, tutorial].map(&:name))
  end

  def expect_to_appear_in_order(strings)
    regex = /#{strings.join(".*")}/m
    expect(page.body).to match(regex)
  end
end
