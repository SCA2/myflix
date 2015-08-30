class WebhooksController < ApplicationController
  
  protect_from_forgery except: :create

  def create
    event = StripeWrapper::Event.retrieve(event_id) if event_id
    if event.valid?
      @object = event.object
      @user = User.find_by(customer_token: @object.customer)
      if @object.object == 'charge' && @object.status == 'succeeded'
        Payment.create(payment_params)
      elsif @object.object == 'charge' && @object.status == 'failed'
        @user.deactivate!
      end
    end
    head :ok
  end

  private

  def event_id
    params.permit(:id)
  end

  def payment_params
    {
      amount: @object.amount,
      user_id: @user.id,
      reference_id: @object.id
    }
  end

end