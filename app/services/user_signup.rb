class UserSignup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(token_params, stripe_params)
    @invitation = Invitation.find_by(token_params)
    @friend = @invitation.user if @invitation
    if @user.valid?
      charge = StripeWrapper::Charge.create(
        source: stripe_params[:source],
        amount: 999,
        description: "MyFlix sign up charge for #{@user.email}"
      )
      if charge.successful?
        @user.save
        mutual_friends if @friend
        UserMailer.welcome(@user).deliver
        @status = :success
        self
      else
        @status = :failure
        @error_message = charge.error_message
        self
      end
    else
      @status = :failure
      @error_message = "Sorry, can't complete sign up. Please correct any errors below."
      self
    end
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