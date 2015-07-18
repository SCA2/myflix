class UserMailer < ActionMailer::Base
  default from: "signup@myflix.com"
  
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to MyFlix!')
  end

  def password_reset(user)
    @user = user
    mail to: @user.email, subject: 'MyFlix Password Reset'
  end

end
