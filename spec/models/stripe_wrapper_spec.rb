require 'spec_helper'

describe StripeWrapper do

  let(:good_token) do
    Stripe::Token.create(
      card: {
        number: "4242424242424242",
        exp_month: Date.today.month,
        exp_year: Date.today.next_year.year,
        cvc: 314
      }
    ).id
  end

  let(:bad_token) do
    Stripe::Token.create(
      card: {
        number: "4000000000000002",
        exp_month: Date.today.month,
        exp_year: Date.today.next_year.year,
        cvc: 314
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe '.create' do
      context 'with valid card' do

        it 'charges the card successfully', :vcr do
          response = StripeWrapper::Charge.create(
            amount:       999,
            source:       good_token,
            description:  'a valid charge'
          )
          expect(response).to be_successful
        end

      end
      
      context 'with invalid card' do

        it 'does not charge the card successfully', :vcr do
          response = StripeWrapper::Charge.create(
            amount:       999,
            source:       bad_token,
            description:  'an invalid charge'
          )
          expect(response).to_not be_successful
        end

        it 'captures the error message', :vcr do
          response = StripeWrapper::Charge.create(
            amount:       999,
            source:       bad_token,
            description:  'an invalid charge'
          )
          expect(response.error_message).to eq "Your card was declined."
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe '.create' do
      context 'with valid card' do

        it 'creates customer', :vcr do
          response = StripeWrapper::Customer.create(
            plan:         '1',
            source:       good_token,
          )
          expect(response).to be_successful
        end

        it 'returns customer token', :vcr do
          response = StripeWrapper::Customer.create(
            plan:         '1',
            source:       good_token,
          )
          expect(response.customer_token).to be_present
        end

      end
      
      context 'with invalid card' do

        it 'does not create customer', :vcr do
          response = StripeWrapper::Customer.create(
            plan:         '1',
            source:       bad_token,
          )
          expect(response).to_not be_successful
        end

        it 'captures the error message', :vcr do
          response = StripeWrapper::Customer.create(
            plan:         '1',
            source:       bad_token,
          )
          expect(response.error_message).to eq "Your card was declined."
        end
      end
    end
  end

  describe StripeWrapper::Event do
    describe '.retrieve' do
      context 'with valid id' do

        path = File.expand_path('../../json/valid_stripe_event.json', __FILE__)
        let(:event) { JSON.parse File.read path }

        it 'returns event', :vcr do
          response = StripeWrapper::Event.retrieve(id: event['id'])
          expect(response).to be_valid
        end

      end
      
      context 'with invalid id' do

        path = File.expand_path('../../json/invalid_stripe_event.json', __FILE__)
        let(:event) { JSON.parse File.read path }

        it 'does not return event', :vcr do
          response = StripeWrapper::Event.retrieve(id: event['id'])
          expect(response).to_not be_valid
        end

        it 'captures the error message', :vcr do
          response = StripeWrapper::Event.retrieve(id: event['id'])
          expect(response.error_message).to include "Stripe::Event instance has invalid ID: nil"
        end
      end
    end
  end
end