class PasswordsController < ApplicationController

  before_action :already_signed_in

  def new
    render 'forgot_password'
  end

  def create
    user = User.find_by(email: params[:email])
    user.send_password_reset if user
    render 'confirm_email_sent'
  end

  def edit
    @user = User.find_by(password_reset_token: params[:id])
    render 'reset_password'
  end

  def update
    user = User.find_by(password_reset_token: params[:id])
    if user.password_reset_sent_at < 1.hour.ago
      flash[:alert] = "Can't update that password!"
      redirect_to home_path
    elsif user.update(password_params)
      flash[:notice] = "Password updated!  Please sign in below."
      redirect_to sign_in_path
    else
      render :edit
    end
  end

  private

  def password_params
    params.permit(:password)
  end

  def already_signed_in
    redirect_to home_path, notice: "Already signed in!" if signed_in?
  end

end