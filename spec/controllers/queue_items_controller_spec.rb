require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    it 'sets @queue_items to current_user queue' do
      @user = Fabricate(:user)
      controller.sign_in(@user)
      @user.queue_items << Fabricate(:queue_item)
      @user.queue_items << Fabricate(:queue_item)
      get :index
      expect(assigns(:queue_items)).to match_array @user.queue_items
    end
    it 'redirects to sign_in_path for unauthenticated user' do
      get :index
      expect(response).to redirect_to sign_in_path
    end
  end
end