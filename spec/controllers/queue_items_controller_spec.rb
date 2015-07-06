require 'spec_helper'

describe QueueItemsController do

  context 'authenticated user' do

    let(:user)  { Fabricate(:user) }
    before { set_current_user(user) }

    describe 'GET index' do
      it 'sets @queue_items to current_user queue' do
        user.queue_items << Fabricate(:queue_item)
        user.queue_items << Fabricate(:queue_item)
        get :index
        expect(assigns(:queue_items)).to match_array user.queue_items
      end
    end

    let(:video_1) { Fabricate(:video) }
    let(:video_2) { Fabricate(:video) }

    describe 'POST create' do
      it 'creates a new queue_item' do
        expect {
          post :create, queue_item: {video_id: video_1}
        }.to change(QueueItem, :count).by 1
      end

      it 'associates video with new queue_item' do
        post :create, queue_item: {video_id: video_1}
        expect(QueueItem.first.video).to eq video_1
      end

      it 'associates user with new queue_item' do
        post :create, queue_item: {video_id: video_1}
        expect(QueueItem.first.user).to eq user
      end

      it 'puts new queue_item last in order' do
        post :create, queue_item: {video_id: video_1}
        post :create, queue_item: {video_id: video_2}
        expect(QueueItem.last.video).to eq video_2
      end

      it 'does not add same video twice' do
        expect {
          post :create, queue_item: {video_id: video_1}
          post :create, queue_item: {video_id: video_1}
        }.to change(QueueItem, :count).by 1
        expect(flash[:alert]).to_not be_blank
      end

      it 'adds same video to different users queues' do
        post :create, queue_item: {video_id: video_1}
        expect(user.queue_items.count).to eq 1
        user_2 = Fabricate(:user)
        set_current_user(user_2)
        post :create, queue_item: {video_id: video_1}
        expect(user_2.queue_items.count).to eq 1
      end

      it 'redirects to queue_items index page' do
        post :create, queue_item: {video_id: video_1}
        expect(response).to redirect_to queue_items_path
      end
    end

    describe 'POST update' do

      let(:item_1) { Fabricate(:queue_item, user: user, video: video_1, order: 1) }
      let(:item_2) { Fabricate(:queue_item, user: user, video: video_2, order: 2) }

      context 'valid data' do

        it 'redirects to queue items index page' do
          post :update_queue, queue_items: [{id: item_1.id, order: 2, rating: 1}, {id: item_2.id, order: 1, rating: 5}]
          expect(response).to redirect_to my_queue_path
        end

        it 'puts queue items in order' do
          post :update_queue, queue_items: [{id: item_1.id, order: 2, rating: 1}, {id: item_2.id, order: 1, rating: 5}]
          expect(user.queue_items).to eq([item_2, item_1])
        end

        it 'starts ordering from 1' do
          post :update_queue, queue_items: [{id: item_1.id, order: 4, rating: 1}, {id: item_2.id, order: 3, rating: 5}]
          expect(user.queue_items.first.order).to eq(1)
          expect(user.queue_items.last.order).to eq(2)
        end
      end

      context 'invalid data' do
        it 'redirects to my_queue_path' do
          post :update_queue, queue_items: [{id: item_1.id, order: 2.5, rating: 1}, {id: item_2.id, order: 1, rating: 5}]
          expect(response).to redirect_to my_queue_path
        end

        it 'sets the flash error message' do
          post :update_queue, queue_items: [{id: item_1.id, order: 2.5, rating: 1}, {id: item_2.id, order: 1, rating: 5}]
          expect(flash[:error]).to be_present
        end

        it 'does not change existing queue items' do
          post :update_queue, queue_items: [{id: item_1.id, order: 3, rating: 1}, {id: item_2.id, order: 2.1, rating: 5}]
          expect(item_1.reload.order).to eq 1
        end
      end

      context 'with other users data' do
        let(:user_2) { Fabricate(:user) }
        let(:item_2) { Fabricate(:queue_item, user: user_2, order: 2)}
        it 'does not change existing queue items' do
          post :update_queue, queue_items: [{id: item_1.id, order: 3, rating: 1}, {id: item_2.id, order: 1, rating: 5}]
          expect(item_1.reload.order).to eq 1
          expect(item_2.reload.order).to eq 2
        end
      end
    end

    describe 'DELETE destroy' do

      let(:user_2) { Fabricate(:user) }

      let!(:item_1)  { Fabricate(:queue_item, video: video_1, user: user) }
      let!(:item_2)  { Fabricate(:queue_item, video: video_2, user: user) }
      let!(:item_3)  { Fabricate(:queue_item, video: video_2, user: user_2) }

      it 'deletes a queue_item' do
        expect {
          delete :destroy, id: item_1
        }.to change(QueueItem, :count).by(-1)
      end

      it 'deletes only the correct queue_item' do
        expect {
          delete :destroy, id: item_3
        }.to change(QueueItem, :count).by(0)
        expect(response).to redirect_to sign_in_path
      end

      it 'orders remaining queue items from 1' do
        delete :destroy, id: item_1
        expect(user.queue_items.first.order).to eq(1)
      end

      it 'redirects to queue items index page' do
        delete :destroy, id: item_1
        expect(response).to redirect_to queue_items_path
      end
    end
  end

  context 'unauthenticated user' do
    describe 'GET index' do
      it_behaves_like 'requires sign in' do
        let(:action) { get :index }
      end
    end

    describe 'POST create' do
      it_behaves_like 'requires sign in' do
        let(:action) { post :create }
      end
    end

    describe 'POST update_queue' do
      it_behaves_like 'requires sign in' do
        let(:action) { post :update_queue }
      end
    end

    describe 'DELETE destroy' do
      it_behaves_like 'requires sign in' do
        let(:action) { delete :destroy, id: 0 }
      end
    end
  end
end