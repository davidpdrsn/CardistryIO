require "rails_helper"

feature "receiving notifications via email" do
  include ActiveJob::TestHelper

  scenario "sends emails right away" do
    perform_enqueued_jobs do
      huron = create :user, username: "huron", admin: true
      daren = create :user, username: "daren"

      visit user_path(huron, as: daren)
      click_link "Follow"

      expect(ActionMailer::Base.deliveries.length).to eq 1
      mail = ActionMailer::Base.deliveries.first
      expect(mail.to).to eq [huron.email]
      expect(mail.from).to eq ["cardistrydotio@gmail.com"]
      expect(mail.subject).to eq "@#{daren.username} is now following you on cardistry.io"
      expect(mail.body.encoded).to include "Hey @#{huron.username}"
    end
  end

  scenario "only sends emails to admins" do
    perform_enqueued_jobs do
      huron = create :user, username: "huron", admin: false
      daren = create :user, username: "daren"

      visit user_path(huron, as: daren)
      click_link "Follow"

      expect(ActionMailer::Base.deliveries.length).to eq 0
    end
  end

  scenario "only sends new follower notifications" do
    perform_enqueued_jobs do
      huron = create :user, username: "huron", admin: true
      daren = create :user, username: "daren", admin: true
      video = create :video, approved: false, user: daren

      visit approve_videos_path(as: huron)
      click_button "Approve"

      expect(ActionMailer::Base.deliveries.length).to eq 0
    end
  end
end
