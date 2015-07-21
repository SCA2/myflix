require 'spec_helper'

describe UsersController do

  context "with new user" do

    describe "GET new" do
      it "creates empty @user variable" do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "GET show" do
      it_behaves_like 'requires sign in' do
        let(:action) { get :show, id: 0 }
      end
    end

    describe "POST create" do

      before  { post :create, user: params }
      after   { ActionMailer::Base.deliveries.clear }

      context "with valid input" do

        let(:params) { Fabricate.attributes_for(:user) }

        it "creates user" do
          expect(User.count).to eq 1
          expect(User.first.email).to eq params[:email]
        end

        it "redirects to home path" do
          expect(response).to redirect_to home_path
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
