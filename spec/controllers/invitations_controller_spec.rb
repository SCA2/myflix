require 'spec_helper'

describe InvitationsController do

  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "creates empty @invitation variable" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end
  end

  describe "POST create" do

    before  { set_current_user }
    before  { post :create, invitation: params }

    context "with valid input" do

      let(:params) { Fabricate.attributes_for(:invitation) }

      it "creates invitation" do
        expect(Invitation.count).to eq 1
        expect(Invitation.first.email).to eq params[:email]
      end

      it "redirects to new invitation path" do
        expect(response).to redirect_to new_invitation_path
      end

      it "sets flash success message" do
        expect(flash[:success]).to be_present
      end

      context "sending email" do

        it "sends email" do
          expect(ActionMailer::Base.deliveries).to_not be_empty
        end

        it "sends to correct recipient" do
          message = ActionMailer::Base.deliveries.last
          expect(message.to.first).to eq params[:email]
        end

        it "has correct content" do
          message = ActionMailer::Base.deliveries.last
          expect(message.body).to include(params[:name])
        end
      end
    end

    context "with invalid input" do

      let(:params) { Fabricate.attributes_for(:invitation, message: '') }

      it "does not create invitation" do
        expect(Invitation.count).to eq 0
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "creates empty @invitation variable" do
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end

      it "does not send email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets flash error message" do
        expect(flash[:error]).to be_present
      end
    end
  end

end