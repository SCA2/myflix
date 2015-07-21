class UserMailer < ActionMailer::Base
  default 

  def welcome(user)
    @user = user
    mail from: 'signup@myflix.com', to: @user.email, subject: 'Welcome to MyFlix!'
  end

  def password_reset(user)
    @user = user
    mail from: 'admin@myflix.com', to: @user.email, subject: 'MyFlix Password Reset'
  end

end
