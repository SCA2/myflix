def set_current_user(user=nil)
  user ||= Fabricate(:user)
  controller.sign_in(user)
end

def set_current_admin(admin=nil)
  admin ||= Fabricate(:admin)
  controller.sign_in(admin)
end

def sign_in_user(user=nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in "Email Address", with: "#{user.email}"
  fill_in "Password", with: "#{user.password}"
  click_button "Sign in"
end

def sign_in_admin(admin=nil)
  admin ||= Fabricate(:admin)
  visit sign_in_path
  fill_in "Email Address", with: "#{admin.email}"
  fill_in "Password", with: "#{admin.password}"
  click_button "Sign in"
end

def sign_out_user
  visit sign_out_path
end

def click_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end

def last_email
  ActionMailer::Base.deliveries.last
end

def reset_email
  ActionMailer::Base.deliveries = []
end