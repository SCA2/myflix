require 'spec_helper'

describe UsersController do

  context "with new user" do

    let(:params) { Fabricate.attributes_for(:user) }

    describe "GET new" do
      it "creates empty @user variable" do
        get :new, user: {email: '', name: '', token: ''}
        expect(assigns(:user)).to be_a_new(User)
      end

      it "sets @user.email if present" do
        get :new, user: params
        expect(assigns(:user).email).to eq(params[:email])
      end

      it "sets @token if present" do
        get :new, user: params.merge(id: 'token')
        expect(assigns(:token)).to eq('token')
      end

      it "redirects to expired token page if token invalid" do
        get :new, user: { token: 'invalid_token' }
        expect(response).to redirect_to expired_token_path
      end
    end

    describe "GET show" do
      it_behaves_like 'requires sign in' do
        let(:action) { get :show, id: 0 }
      end
    end

    describe "POST create" do

      context "with valid input" do

        before  { StripeMock.start }
        after   { StripeMock.stop }
        
        let(:params)  { Fabricate.attributes_for(:user) }

        it "creates user" do
          post :create, user: params
          expect(User.count).to eq 1
        end

        it "redirects to home path" do
          post :create, user: params
          expect(response).to redirect_to home_path
        end

        it "makes user a leading influence if invited" do
          inviter = Fabricate(:user)
          inviter.invitations << Fabricate(:invitation, email: params[:email])
          inviter.invitations.first.send_invitation
          token = inviter.invitations.first.invitation_token
          post :create, user: params.merge(id: token)
          expect(inviter.followers.first).to eq User.second
        end

        it "makes friend a leading influence if inviter" do
          inviter = Fabricate(:user)
          inviter.invitations << Fabricate(:invitation, email: params[:email])
          inviter.invitations.first.send_invitation
          token = inviter.invitations.first.invitation_token
          post :create, user: params.merge(id: token)
          expect(User.second.followers.first).to eq inviter
        end

        it "destroys accepted invitation" do
          inviter = Fabricate(:user)
          inviter.invitations << Fabricate(:invitation, email: params[:email])
          inviter.invitations.first.send_invitation
          token = inviter.invitations.first.invitation_token
          post :create, user: params.merge(id: token)
          expect(Invitation.count).to eq 0
        end

        context "sending email" do

          before { post :create, user: params }

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

        before { post :create, user: params }

        let(:params) { Fabricate.attributes_for(:user, password: '') }

        it "does not create user" do
          expect(User.count).to eq 0
        end

        it "renders :new template" do
          expect(response).to render_template :new
        end

        it "creates empty @user variable" do
          expect(assigns(:user)).to be_a_new(User)
        end

        it "does not send email" do
          expect(ActionMailer::Base.deliveries).to be_empty
        end
      end
    end
  end
  
  context "with signed_in user" do

    before { set_current_user }

    describe "GET new" do
      it_behaves_like 'already signed in' do
        let(:action) { get :new }
      end
    end

    describe "POST create" do
      it_behaves_like 'already signed in' do
        let(:action) { post :create }
      end
    end

    describe "GET show" do
      it "assigns @user to current user" do
        get :show, id: controller.current_user.id
        expect(assigns(:user)).to eq controller.current_user
      end

      it "assigns @reviews to current user reviews" do
        get :show, id: controller.current_user.id
        expect(assigns(:reviews)).to eq controller.current_user.reviews
      end

      it "assigns @queue to current user queue items" do
        get :show, id: controller.current_user.id
        expect(assigns(:queue)).to eq controller.current_user.queue_items
      end
    end

  end

end
