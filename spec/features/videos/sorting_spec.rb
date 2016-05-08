require "rails_helper"

feature "sorting" do
  scenario "sorting by created at by default" do
    one = create :video, created_at: Time.zone.now
    two = create :video, created_at: 2.days.ago
    three = create :video, created_at: 2.weeks.ago

    visit all_videos_path

    expect_to_appear_in_order([one, two, three].map(&:name))
  end

  def expect_to_appear_in_order(strings)
    regex = /#{strings.join(".*")}/m
    expect(page.body).to match(regex)
  end
end
