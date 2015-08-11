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
    @invitation = Invitation.find_by(token_params)
    @friend = @invitation.user if @invitation
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        stripe_params(
          amount: 999,
          description: "MyFlix sign up charge for #{@user.email}"
        )
      )
      if charge.successful?
        @user.save
        mutual_friends if @friend
        UserMailer.welcome(@user).deliver
        sign_in @user
        flash[:success] = "Signed up!"
        redirect_to home_path
      else
        flash[:error] = charge.error_message
        render :new
      end
    else
      flash[:error] = "Sorry, can't complete sign up"
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

  def stripe_params(options = {})
    params.require(:user).permit(:source).merge(options)
  end

  def mutual_friends
    @user.follow(@friend)
    @friend.follow(@user)
    @invitation.destroy
  end

end