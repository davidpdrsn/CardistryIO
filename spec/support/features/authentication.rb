module Features
  def sign_up(email: "bob@example.com", password: "secret")
    visit root_path
    click_link "Sign up"
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Sign up"
  end
end
