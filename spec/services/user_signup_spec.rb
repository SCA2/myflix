require 'spec_helper'

describe UserSignup do

  let(:token_params)  { Hash[invitation_token: "test_invitation_token"] }
  let(:stripe_params) { Hash[source: "test_stripe_token"] }

  describe '#sign_up' do

    let(:new_user)    { Fabricate.build(:user) }

    context "with valid user and credit card info" do

      let(:customer)    { double(:customer, successful?: true, customer_token: new_user[:customer_token]) }
      let(:user_params) { Fabricate.attributes_for(:user) }

      before { expect(StripeWrapper::Customer).to receive(:create).and_return(customer) }

      it "creates user" do
        UserSignup.new(new_user).sign_up(token_params, stripe_params)
        expect(User.count).to eq 1
      end

      it "saves stripe customer token" do
        UserSignup.new(new_user).sign_up(token_params, stripe_params)
        expect(User.first.customer_token).to eq new_user[:customer_token]
      end

      context "invitations" do

        let(:inviter) { Fabricate(:user) }

        before do
          inviter.invitations << Fabricate(:invitation)
          inviter.invitations.first.send_invitation
          token = Hash[invitation_token: inviter.invitations.first.invitation_token]
          UserSignup.new(new_user).sign_up(token, stripe_params)
        end

        it "makes user a leading influence if invited" do
          expect(inviter.followers.first).to eq User.second
        end

        it "makes friend a leading influence if inviter" do
          expect(User.second.followers.first).to eq inviter
        end

        it "destroys accepted invitation" do
          expect(Invitation.count).to eq 0
        end
      end

      context "sending email" do

        before { UserSignup.new(new_user).sign_up(token_params, stripe_params) }

        it "sends email" do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end

        it "sends to correct recipient" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to.first).to eq new_user.email
        end

        it "has correct content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(new_user.name)
        end
      end
    end

    context "with valid user and invalid credit card" do

      let(:customer) { double(:customer, successful?: false, error_message: "Fail") }

      it "does not create new user" do
        expect(StripeWrapper::Customer).to receive(:create).and_return(customer)
        UserSignup.new(new_user).sign_up(token_params, stripe_params)
        expect(User.count).to eq 0
      end

    end
  end

  context "with invalid user info" do

    let(:bad_user) { Fabricate.build(:user, password: '') }

    before { UserSignup.new(bad_user).sign_up(token_params, stripe_params) }

    it "does not create new user" do
      expect(User.count).to eq 0
    end

    it "does not send email" do
      expect(ActionMailer::Base.deliveries).to be_empty
    end

    it "does not attempt to charge a card" do
      expect(StripeWrapper::Charge).not_to receive(:create)
    end
  end
end