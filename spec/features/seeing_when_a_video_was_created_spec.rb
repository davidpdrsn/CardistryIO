require "rails_helper"

feature "seeing when a video was created spec" do
  scenario "sees the time" do
    Time.use_zone("Hawaii") do
      user = create :user, time_zone: "Central Time (US & Canada)"
      video = create :video

      visit video_path(video, as: user)

      created_at_in_time_zone = video
        .created_at
        .in_time_zone(user.time_zone)
        .to_formatted_s(:long)

      expect(page).to have_content(created_at_in_time_zone)
    end
  end
end
