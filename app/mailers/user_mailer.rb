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

  def invitation(invitee)
    @inviter = invitee.user
    @invitee = invitee
    mail from: @inviter.email, to: @invitee.email, subject: 'Want to Join MyFlix?'
  end

end
