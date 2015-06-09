require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do

    let(:video) { Fabricate(:video) }

    context 'with authenticated user' do

      before { set_current_user }

      describe 'with valid data' do
        before do
          post  :create,
                review: Fabricate.attributes_for(:review, user: @user, video: video),
                video_id: video.id
        end

        it 'creates a review' do
          expect(Review.count).to eq 1
        end

        it 'creates video association' do
          expect(Review.first).to eq video.reviews.first
        end

        it 'creates authenticated user association' do
          expect(Review.first).to eq @user.reviews.first
        end

        it 'redirects to video show page' do
          expect(response).to redirect_to video
        end
      end

      describe 'with invalid data' do
        before do
          post  :create,
                review: Fabricate.attributes_for(:review, rating: nil, user: @user, video: video),
                video_id: video.id
        end

        it 'does not create a review' do
          expect(Review.count).to eq 0
        end

        it 'renders the videos#show template' do
          expect(response).to render_template 'videos/show'
        end

        it 'sets @video' do
          expect(assigns(:video)).to eq video
        end

        it 'sets @reviews' do
          expect(assigns(:reviews)).to eq video.reviews
        end
      end
    end

    context 'with unauthenticated user' do
      it_behaves_like 'requires sign in' do
        let(:action) { post  :create,
          review: Fabricate.attributes_for(:review, video: video),
          video_id: video.id
        }
      end
    end

  end
end