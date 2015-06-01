require 'spec_helper'

describe SessionsController do

  context "unauthenticated user" do

    describe "GET new" do
      it "renders new template" do
        get :new
        expect(response).to render_template :new
      end
    end

    describe "POST create" do

      let(:params) { Fabricate.attributes_for(:user) }

      context "with valid input" do
        before(:each) do
          user = User.create(params)
          post :create, user: params
        end

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
        before(:each) do
          user = User.create(params)
          params[:email] = ""
          post :create, user: params
        end

        it "does not create session" do
          expect(controller.signed_in?).to eq false
        end

        it "renders new template" do
          expect(response).to render_template :new
        end

        it "sets flash error" do
          expect(flash[:error]).to be_present
        end
      end
    end
  end
  
  context "authenticated user" do

    before(:each) do
      user = Fabricate(:user)
      controller.sign_in(user)
    end

    describe "GET new" do
      it "redirects to home path" do
        get :new
        expect(response).to redirect_to home_path
        expect(flash[:notice]).to be_present
      end
    end

    describe "POST create" do
      it "redirects to home path" do
        post :create
        expect(response).to redirect_to home_path
        expect(flash[:notice]).to be_present
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
end
