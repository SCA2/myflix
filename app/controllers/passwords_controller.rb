class PasswordsController < ApplicationController

  before_action :already_signed_in

  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_password_reset
    else
      flash[:error] = params[:email].blank? ? "Email can't be blank!" : "Unknown email address!"
      redirect_to new_password_path
    end
  end

  def edit
    @user = User.find_by(password_reset_token: params[:id])
    redirect_to expired_token_path and return unless @user
    if @user.password_reset_sent_at < 1.hour.ago
      @user.cleanup_password_reset
      redirect_to expired_token_path
    end
  end

  def update
    user = User.find_by(password_reset_token: params[:id])
    redirect_to expired_token_path and return unless user
    if user.password_reset_sent_at < 1.hour.ago
      redirect_to expired_token_path
    elsif user.update(password_params)
      flash[:success] = "Password updated!  Please sign in below."
      redirect_to sign_in_path
    end
    user.cleanup_password_reset
  end

  private

  def password_params
    params.permit(:password)
  end

  def already_signed_in
    redirect_to home_path, notice: "Already signed in!" if signed_in?
  end

end