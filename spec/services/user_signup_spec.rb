require 'spec_helper'

describe UserSignup do

  let(:token_params)  { Hash[invitation_token: "test_invitation_token"] }
  let(:stripe_params) { Hash[source: "test_stripe_token"] }

  describe '#sign_up' do

    let(:new_user)    { Fabricate.build(:user) }

    context "with valid user and credit card info" do

      let(:charge)        { double(:charge, successful?: true) }
      let(:user_params)   { Fabricate.attributes_for(:user) }

      before { expect(StripeWrapper::Charge).to receive(:create).and_return(charge) }

      it "creates user" do
        UserSignup.new(new_user).sign_up(token_params, stripe_params)
        expect(User.count).to eq 1
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

      let(:charge) { double(:charge, successful?: false, error_message: "Fail") }

      it "does not create new user" do
        expect(StripeWrapper::Charge).to receive(:create).and_return(charge)
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