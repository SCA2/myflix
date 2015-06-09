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

      context "with valid input" do

        let(:params) { Fabricate.attributes_for(:user) }

        it "creates user" do
          expect(User.count).to eq 1
          expect(User.first.email).to eq params[:email]
        end

        it "redirects to home path" do
          expect(response).to redirect_to home_path
        end
      end

      context "with invalid input" do

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
  end

end
