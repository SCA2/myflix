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

      context "successful user sign up" do

        let(:params)  { Fabricate.attributes_for(:user) }
        let(:result)  { double(:sign_up_result, successful?: true) }
        
        before do
          expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
          post :create, user: params
        end

        it "sets flash success message" do
          expect(flash[:success]).to be_present
        end

        it "redirects to home path" do
          expect(response).to redirect_to home_path
        end
      end

      context "with invalid credit card or user info" do

        let(:result)  { double(:sign_up_result, successful?: false, error_message: "Fail") }
        
        before do
          expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
          post :create, user: params
        end

        it "sets flash error message" do
          expect(flash[:error]).to eq "Fail"
        end

        it "renders :new template" do
          expect(response).to render_template :new
        end

        it "creates empty @user variable" do
          expect(assigns(:user)).to be_a_new(User)
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
