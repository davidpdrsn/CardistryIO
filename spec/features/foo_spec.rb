require "rails_helper"

feature "running js" do
  scenario "rendering directly from controller action", :js do
    visit "/from_action"
    expect(page).to have_content "Hello World"
  end

  scenario "from inline script", :js do
    visit "/from_inline_script"
    expect(page).to have_content "Hello World"
  end

  scenario "from application.js", :js do
    visit "/from_application_js"
    expect(page).to have_content "Hello World"
  end
end
