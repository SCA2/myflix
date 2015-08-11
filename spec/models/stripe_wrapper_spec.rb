require 'spec_helper'

describe StripeWrapper::Charge do

  describe '.create' do
    context 'with valid card' do

      let(:token) do
        Stripe::Token.create(
          card: {
            number: "4242424242424242",
            exp_month: Date.today.month,
            exp_year: Date.today.next_year.year,
            cvc: 314
          }
        ).id
      end

      it 'charges the card successfully', :vcr do
        response = StripeWrapper::Charge.create(
          amount:       999,
          source:       token,
          description:  'a valid charge'
        )
        expect(response).to be_successful
      end

    end
    
    context 'with invalid card' do

      let(:token) do
        Stripe::Token.create(
          card: {
            number: "4000000000000002",
            exp_month: Date.today.month,
            exp_year: Date.today.next_year.year,
            cvc: 314
          }
        ).id
      end

      it 'does not charge the card successfully', :vcr do
        response = StripeWrapper::Charge.create(
          amount:       999,
          source:       token,
          description:  'an invalid charge'
        )
        expect(response).to_not be_successful
      end

      it 'captures the error message', :vcr do
        response = StripeWrapper::Charge.create(
          amount:       999,
          source:       token,
          description:  'an invalid charge'
        )
        expect(response.error_message).to eq "Your card was declined."
      end
    end
  end
end