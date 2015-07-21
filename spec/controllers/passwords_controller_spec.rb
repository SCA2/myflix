require 'spec_helper'

describe PasswordsController do
  describe 'POST create' do
    
    let(:user) { Fabricate(:user) }

    context 'bad input' do
      it 're-prompts for email address' do
        post :create, email: ''
        expect(response).to redirect_to new_password_path
      end

      it 'shows an error message' do
        post :create, email: ''
        expect(flash[:error]).to eq "Email can't be blank!"
      end
    end

    context 'good input' do
      it 'sends password reset email' do
        post :create, email: user.email
        expect(last_email.to).to include user.email
      end

      it 'renders notification page' do
        post :create, email: user.email
        expect(response).to render_template :create
      end
    end

    context 'unknown user' do
      it 're-prompts for email address' do
        post :create, email: 'unknown@example.com'
        expect(response).to redirect_to new_password_path
      end

      it 'shows an error message' do
        post :create, email: 'unknown@example.com'
        expect(flash[:error]).to eq "Unknown email address!"
      end
    end
  end

  describe "GET edit" do

    let(:user)  { Fabricate(:user) }
    before      { user.send_password_reset }

    it 'sets @user instance variable' do
      get :edit, email: user.email, id: user.password_reset_token
      expect(assigns(:user)).to eq(user)
    end

    it 'renders edit template if token is valid' do
      get :edit, email: user.email, id: user.password_reset_token
      expect(response).to render_template :edit
    end

    it 'redirects to expired token path if token invalid' do
      get :edit, email: user.email, id: ''
      expect(response).to redirect_to expired_token_path
    end

    it 'sets user.password_reset_token to nil if token expired' do
      user.update!(password_reset_sent_at: 2.hours.ago)
      get :edit, email: user.email, id: user.password_reset_token
      expect(user.reload.password_reset_token).to eq nil
    end

    it 'sets user.password_reset_sent_at to nil if token expired' do
      user.update!(password_reset_sent_at: 2.hours.ago)
      get :edit, email: user.email, id: user.password_reset_token
      expect(user.reload.password_reset_sent_at).to eq nil
    end
  end

  describe "PATCH update" do

    let(:user)  { Fabricate(:user) }
    before      { user.send_password_reset }

    it 'updates password if token is valid' do
      patch :update, password: 'new_password', id: user.password_reset_token
      expect(user.reload.authenticate('new_password').id).to eq user.id
    end

    it 'redirects to sign_in path if token is valid' do
      patch :update, password: 'password', id: user.password_reset_token
      expect(response).to redirect_to sign_in_path
    end

    it 'sets flash success message' do
      patch :update, password: 'password', id: user.password_reset_token
      expect(flash[:success]).to be_present
    end

    it 'redirects to expired token path if token is expired' do
      user.update!(password_reset_sent_at: 2.hours.ago)
      patch :update, password: 'password', id: user.password_reset_token
      expect(response).to redirect_to expired_token_path
    end

    it "redirects to expired token path if user can't be found" do
      patch :update, password: 'password', id: ''
      expect(response).to redirect_to expired_token_path
    end

    it 'sets user.password_reset_token to nil' do
      patch :update, password: 'password', id: user.password_reset_token
      expect(user.reload.password_reset_token).to eq nil
    end

    it 'sets user.password_reset_sent_at to nil' do
      patch :update, password: 'password', id: user.password_reset_token
      expect(user.reload.password_reset_sent_at).to eq nil
    end
  end
end