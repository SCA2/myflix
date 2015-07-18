class UsersController < ApplicationController

  before_action :already_signed_up, only: [:new, :create]
  before_action :authorize, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
    @queue = @user.queue_items
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome(@user).deliver
      sign_in @user
      flash[:success] = "Signed up!"
      redirect_to home_path
    else
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
end