require 'spec_helper'

describe SessionsController do

  context "authenticated user" do

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

    describe "GET destroy" do

      before(:each) { get :destroy }

      it "clears the session" do
        expect(controller.signed_in?).to eq false
      end

      it "redirects to root url" do
        expect(response).to redirect_to root_url
      end

      it "sets flash notice" do
        expect(flash[:notice]).to be_present
      end
    end
  end
  
  context "unauthenticated user" do

    describe "GET new" do
      it "renders new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST create" do

      let(:good_params) { Fabricate.attributes_for(:user) }
      let(:bad_params)  { Fabricate.attributes_for(:user, email: "") }
      let!(:user)       { Fabricate(:user, good_params) }

      context "with valid input" do
        
        before { post :create, user: good_params }

        it "creates session" do
          expect(controller.signed_in?).to eq true
        end

        it "redirects to home_path" do
          expect(response).to redirect_to home_path
        end

        it "sets flash notice" do
          expect(flash[:notice]).to be_present
        end
      end

      context "with invalid input" do
        
        before { post :create, user: bad_params }

        it "does not create session" do
          expect(controller.signed_in?).to eq false
        end

        it "redirects to sign_in path" do
          expect(response).to redirect_to sign_in_path
        end

        it "sets flash error" do
          expect(flash[:error]).to be_present
        end
      end
    end
  end
  
end
