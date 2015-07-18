class PasswordsController < ApplicationController

  before_action :already_signed_in

  def forgot
    render 'forgot_password'
  end

  def email
    user = User.find_by(email: params[:email])
    UserMailer.password_reset(user).deliver
    render 'confirm_email_sent'
  end

  def new
    render 'reset_password'
  end

  def update
    redirect_to sign_in_path
  end

  private

  def already_signed_in
    redirect_to home_path, notice: "Already signed in!" if signed_in?
  end

end