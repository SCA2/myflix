class SessionsController < ApplicationController

  before_action :already_signed_in

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      sign_in(user)
      redirect_to home_path, notice: "Signed in!"
    else
      flash.now[:error] = "Email or password is invalid"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_url, notice: "Signed out!"
  end

  private

  def already_signed_in
    redirect_to home_path, notice: "Already signed in!" if signed_in?
  end

  def session_params
    params.permit(:email, :password)
  end
end