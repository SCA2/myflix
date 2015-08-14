class UsersController < ApplicationController

  before_action :already_signed_up, only: [:new, :create]
  before_action :authorize, only: [:show]

  def new
    if params[:user]
      @user = User.new(user_params)
      @token = params[:user][:id]
      redirect_to expired_token_path unless
        @token && Invitation.find_by(invitation_token: @token)
    else
      @user = User.new
    end
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
    @queue = @user.queue_items
  end

  def create
    @user = User.new(user_params)
    response = UserSignup.new(@user).sign_up(token_params, stripe_params)
    if response.successful?
      sign_in @user
      flash[:success] = "Signed up!"
      redirect_to home_path
    else
      flash.now[:error] = response.error_message
      render :new
    end
  end

  private

  def already_signed_up
    redirect_to home_path, notice: "Already signed up!" if signed_in?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def token_params
    params.require(:user).permit(:invitation_token)
  end

  def stripe_params
    params.permit(:source)
  end

end