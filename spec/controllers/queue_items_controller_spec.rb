require 'spec_helper'

describe QueueItemsController do
  context 'authenticated user' do
    before do
      @user = Fabricate(:user)
      controller.sign_in(@user)
    end

    describe 'GET index' do
      it 'sets @queue_items to current_user queue' do
        @user.queue_items << Fabricate(:queue_item)
        @user.queue_items << Fabricate(:queue_item)
        get :index
        expect(assigns(:queue_items)).to match_array @user.queue_items
      end
    end

    let(:video) { Fabricate(:video) }
    let(:video_2) { Fabricate(:video) }
    describe 'POST create' do
      it 'creates a new queue_item' do
        count = QueueItem.count
        post :create, queue_item: {user_id: @user, video_id: video}
        expect(QueueItem.count).to eq count + 1
      end
      it 'associates video with new queue_item' do
        post :create, queue_item: {user_id: @user, video_id: video}
        expect(QueueItem.last.video).to eq video
      end
      it 'associates user with new queue_item' do
        post :create, queue_item: {user_id: @user, video_id: video}
        expect(QueueItem.last.user).to eq @user
      end
      it 'puts new queue_item last in order' do
        post :create, queue_item: {user_id: @user, video_id: video}
        post :create, queue_item: {user_id: @user, video_id: video_2}
        expect(QueueItem.last.video).to eq video_2
      end
      it 'does not add same video twice' do
        count = QueueItem.count
        post :create, queue_item: {user_id: @user, video_id: video}
        post :create, queue_item: {user_id: @user, video_id: video}
        expect(QueueItem.count).to eq count + 1
        expect(flash[:alert]).to_not be_blank
      end
      it 'redirects to queue_items index page' do
        post :create, queue_item: {user_id: @user, video_id: video}
        expect(response).to redirect_to queue_items_path
      end
    end

    describe 'DELETE destroy' do
      let(:user_2) { Fabricate(:user) }
      before do
        @queue_item = Fabricate(:queue_item, video: video, user: @user)
        @queue_item_2 = Fabricate(:queue_item, video: video_2, user: user_2)
      end
      it 'deletes a queue_item' do
        count = QueueItem.count
        delete :destroy, id: @queue_item
        expect(QueueItem.count).to eq(count - 1)
      end
      it 'deletes only the correct queue_item' do
        count = QueueItem.count
        delete :destroy, id: @queue_item_2
        expect(QueueItem.count).to eq(count)
        expect(response).to redirect_to sign_in_path
      end
      it 'redirects to queue items index page' do
        delete :destroy, id: @queue_item
        expect(response).to redirect_to queue_items_path
      end
    end
  end

  context 'unauthenticated user' do
    describe 'GET index' do
      it 'redirects to sign_in_path' do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
    describe 'POST create' do
      it 'redirects to sign_in_path' do
        post :create
        expect(response).to redirect_to sign_in_path
      end
    end
    describe 'DELETE destroy' do
      it 'redirects to sign_in_path' do
        delete :destroy, id: 0
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end