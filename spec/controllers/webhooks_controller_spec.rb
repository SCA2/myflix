require 'spec_helper'

describe WebhooksController do
  describe 'POST create' do
    context 'with successful payment', :vcr do

      path = File.expand_path('../../json/valid_stripe_event.json', __FILE__)

      let(:params)        { JSON.parse File.read path }
      let(:token)         { params['data']['object']['customer'] }
      let(:amount)        { params['data']['object']['amount'] }
      let(:reference_id)  { params['data']['object']['id'] }
      let(:new_user)      { Fabricate.attributes_for(:user, customer_token: token) }

      before { User.create(new_user) }

      it 'creates a new payment' do
        post :create, params
        expect(Payment.count).to eq 1
      end

      it "associates stripe payment with user" do
        post :create, params
        expect(Payment.first.user).to eq User.last
      end

      it 'creates payment with correct amount' do
        post :create, params
        expect(Payment.first.amount).to eq amount
      end

      it 'creates payment with correct id' do
        post :create, params
        expect(Payment.first.reference_id).to eq reference_id
      end

    end

    context 'with failed charge', :vcr do

      path = File.expand_path('../../json/failed_stripe_payment.json', __FILE__)

      let(:params)        { JSON.parse File.read path }
      let(:token)         { params['data']['object']['customer'] }
      let!(:user)          { Fabricate(:user, customer_token: token) }

      it 'does not create a new payment' do
        post :create, params
        expect(Payment.count).to eq 0
      end

      it "deactivates user" do
        post :create, params
        expect(user.reload).not_to be_active
      end

    end

    context 'with invalid event' do

      path = File.expand_path('../../json/invalid_stripe_event.json', __FILE__)
      let(:params) { JSON.parse File.read path }

      before do
        set_current_admin
        post :create, params
      end

      it 'does not create a new payment' do
        expect(Payment.count).to eq 0
      end
    end
  end
end