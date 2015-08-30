class UserSignup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(token_params, stripe_params)
    @invitation = Invitation.find_by(token_params)
    @friend = @invitation.user if @invitation
    if @user.valid?
      customer = StripeWrapper::Customer.create(
        source: stripe_params[:source],
        plan: '1',
        description: "Sign up #{@user.email} for MyFlix Basic"
      )
      if customer.successful?
        @user.customer_token = customer.customer_token
        @user.save
        mutual_friends if @friend
        UserMailer.welcome(@user).deliver
        @status = :success
      else
        @status = :failure
        @error_message = customer.error_message
      end
    else
      @status = :failure
      @error_message = "Sorry, can't complete sign up. Please correct any errors below."
    end
    self
  end

  def successful?
    @status == :success
  end

  def mutual_friends
    @user.follow(@friend)
    @friend.follow(@user)
    @invitation.destroy
  end
end