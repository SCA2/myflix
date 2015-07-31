require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it 'initializes @video with new Video' do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it 'redirects regular user to home path' do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it 'sets flash error for regular user' do
      set_current_user
      get :new
      expect(flash[:error]).to be_present
    end

    it 'does not set flash error for admin' do
      set_current_admin
      get :new
      expect(flash[:error]).to_not be_present
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end
  end

  describe 'GET index' do
  end
end