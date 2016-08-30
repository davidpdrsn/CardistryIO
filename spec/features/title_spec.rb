require "rails_helper"

feature "<title>" do
  scenario "shows the username on users' profiles" do
    huron = create :user, username: "Huron"

    visit user_path(huron)

    expect(page.body).to include "Huron | CardistryIO"
  end
end
