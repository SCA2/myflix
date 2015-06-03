require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    let(:fab_video) { Fabricate(:video) }
    context 'with authenticated user' do

      before(:each) do
        @user = Fabricate(:user)
        controller.sign_in(@user)
      end

      describe 'with valid data' do
        before do
          post  :create,
                review: Fabricate.attributes_for(:review, user: @user, video: fab_video),
                video_id: fab_video.id
        end
        it 'creates a review' do
          expect(Review.count).to eq 1
        end
        it 'creates video association' do
          expect(Review.first).to eq fab_video.reviews.first
        end
        it 'creates authenticated user association' do
          expect(Review.first).to eq @user.reviews.first
        end
        it 'redirects to video show page' do
          expect(response).to redirect_to fab_video
        end
      end
      describe 'with invalid data' do
        before do
          post  :create,
                review: Fabricate.attributes_for(:review, rating: nil, user: @user, video: fab_video),
                video_id: fab_video.id
        end
        it 'does not create a review' do
          expect(Review.count).to eq 0
        end
        it 'renders the videos#show template' do
          expect(response).to render_template 'videos/show'
        end
        it 'sets @video' do
          expect(assigns(:video)).to eq fab_video
        end
        it 'sets @reviews' do
          expect(assigns(:reviews)).to eq fab_video.reviews
        end
      end
    end
    context 'with unauthenticated user' do
      it 'redirects to sign_in path' do
        post  :create,
              review: Fabricate.attributes_for(:review, video: fab_video),
              video_id: fab_video.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end