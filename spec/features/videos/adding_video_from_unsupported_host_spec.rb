require "rails_helper"

feature "adding video from unsupported host" do
  scenario "it fails gracefully" do
    bob = create :user
    attributes = attributes_for :video

    visit new_video_path(as: bob)
    fill_in "Name", with: attributes[:name]
    fill_in "Description", with: attributes[:description]
    fill_in "URL", with: "http://example.com"
    click_button "Submit video"

    expect(page).to have_content "is not supported"
  end
end
