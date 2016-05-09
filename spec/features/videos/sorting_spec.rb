require "rails_helper"

feature "sorting" do
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
    create :rating, rateable: one, rating: 5

    two = create :video, created_at: 2.days.ago
    create :rating, rateable: two, rating: 3

    three = create :video, created_at: 10.weeks.ago
    create :rating, rateable: three, rating: 1

    visit all_videos_path
    select "Rating", from: "sort_by"
    select "Highest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  scenario "sorting by rating in reverse" do
    one = create :video, created_at: Time.zone.now
    create :rating, rateable: one, rating: 5

    two = create :video, created_at: 2.days.ago
    create :rating, rateable: two, rating: 3

    three = create :video, created_at: 10.weeks.ago
    create :rating, rateable: three, rating: 1

    visit all_videos_path
    select "Rating", from: "sort_by"
    select "Lowest", from: "sort_direction"
    click_button "Go"

    expect_to_appear_in_order([three, two, one].map(&:name))
  end

  def expect_to_appear_in_order(strings)
    regex = /#{strings.join(".*")}/m
    expect(page.body).to match(regex)
  end
end
