require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    it_behaves_like 'requires admin' do
      let(:action) { get :new }
    end

    it_behaves_like 'requires sign in' do
      let(:action) { get :new }
    end
    
    it 'initializes @video with new Video' do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
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
  end

  describe 'GET index' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end
  end

  describe 'POST create' do
    it_behaves_like 'requires sign in' do
      let(:action) { post :create }
    end

    it_behaves_like 'requires admin' do
      let(:action) { post :create }
    end

    context 'with valid input' do
      let!(:category) { Fabricate(:category) }
      let(:params)    { Fabricate.attributes_for(:video, category: category) }
      before          { set_current_admin }
      before          { post :create, video: params }

      it 'creates a new video' do
        expect(category.videos.count).to eq 1
      end

      it 'redirects to the new video page' do
        expect(response).to redirect_to new_admin_video_path
      end

      it 'sets flash success message' do
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid input' do
      let(:params)  { Fabricate.attributes_for(:video, category: nil) }
      before        { set_current_admin }
      before        { post :create, video: params }

      it 'does not create a new video' do
        expect(Video.count).to eq 0
      end

      it 'renders :new template' do
        expect(response).to render_template :new
      end

      it 'initializes @video' do
        expect(assigns(:video)).to be_instance_of Video
        expect(assigns(:video)).to be_new_record
      end

      it 'sets flash error message' do
        expect(flash[:error]).to be_present
      end
    end
  end
end