def set_current_user(user=nil)
  user ||= Fabricate(:user)
  controller.sign_in(user)
end

def sign_in_user(user=nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: "#{user.email}"
  fill_in "Password", with: "#{user.password}"
  click_button "Sign in"
end