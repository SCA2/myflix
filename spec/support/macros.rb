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

def click_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end

def last_email
  ActionMailer::Base.deliveries.last
end

def reset_email
  ActionMailer::Base.deliveries = []
end