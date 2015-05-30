class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    # if signed_in?
    #   flash[:notice] = "Already signed up!"
    #   redirect_to home_path
    # else
      @user = User.new(user_params)
      if @user.save
        # sign_in @user
        # UserMailer.signup_confirmation(@user).deliver
        flash[:success] = "Signed up! Please sign in."
        redirect_to sign_in_path
      else
        render :new
      end
    # end
  end

  private

  def user_params
      params.require(:user).permit(:name, :email, :password)
  end
end