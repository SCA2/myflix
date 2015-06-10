def set_current_user(user=nil)
  @user = user || Fabricate(:user)
  controller.sign_in(@user)
end

def sign_in_user(new_user=nil)
  user = new_user || Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: "#{user.email}"
  fill_in "Password", with: "#{user.password}"
  click_button "Sign in"
  expect(page).to have_content "#{user.name}"
  expect(page).to have_selector "#flash_notice", text: "Signed in!"
  expect(page.current_path).to eq "/home"
end