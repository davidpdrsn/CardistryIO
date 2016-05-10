module Features
  def sign_up(options = {})
    email = options.fetch(:email, "kevin@example.com")
    username = options.fetch(:username, "visualmadness")
    password = options.fetch(:password, "passwordlol")

    visit root_path
    click_link "Sign up"
    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "Username", with: username
    select "Denmark", from: "Country"
    select "Central Time (US & Canada)", from: "Time zone"
    click_button "Sign up"
  end
end
