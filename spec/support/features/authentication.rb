module Features
  def sign_up(options = {})
    email = options[:email] || "kevin@example.com"
    password = options[:password] || "passwordlol"
    first_name = options[:first_name] || "Kevin"
    last_name = options[:last_name] || "Ho"

    visit root_path
    click_link "Sign up"
    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "First name", with: "Kevin"
    fill_in "Last name", with: "Ho"
    click_button "Sign up"
  end
end
