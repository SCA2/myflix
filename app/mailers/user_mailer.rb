class UserMailer < ActionMailer::Base
  default from: "signup@myflix.com"
  
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to MyFlix!')
  end
end
