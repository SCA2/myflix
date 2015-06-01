require 'spec_helper'

describe UsersController do

  context "with new user" do

    describe "GET new" do
      it "creates empty @user variable" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "POST create" do
      before { post :create, user: params }
      context "with good input" do
        let(:params) { Fabricate.attributes_for(:user) }
        it "creates user" do
          expect(User.count).to eq 1
          expect(User.first.email).to eq params[:email]
        end
        it "redirects to home path" do
          expect(response).to redirect_to home_path
        end
      end
      context "with bad input" do
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
      end
    end

  end
  
  context "with signed_in user" do

    before(:each) do
      user = Fabricate(:user)
      controller.sign_in(user)
    end

    describe "GET new" do
      it "redirects to home path" do
        get :new
        expect(response).to redirect_to home_path
      end
    end

    describe "POST create" do
      it "redirects to home path" do
        post :create
        expect(response).to redirect_to home_path
      end
    end
  end
end
