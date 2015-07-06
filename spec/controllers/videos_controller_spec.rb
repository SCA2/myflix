require 'spec_helper'

describe VideosController do

  context "with authenticated user" do

    before { set_current_user }

    describe "GET index" do
      it "sets @categories variable" do
        category = Fabricate(:category)
        get :index
        expect(assigns(:categories)).to eq [category]
      end
    end

    describe "GET show" do
      let(:video)   { Fabricate(:video) }
      let(:review_1)  { Fabricate(:review, video: video) }
      let(:review_2)  { Fabricate(:review, video: video) }

      it "sets @video variable" do
        get :show, id: video.id
        expect(assigns(:video)).to eq video
      end

      it "sets @reviews variable" do
        get :show, id: video.id
        expect(assigns(:reviews)).to include review_1, review_2
      end
    end

    describe "GET search" do
      it "sets @videos variable" do
        a =   Fabricate(:video, title: 'a')
        b1 =  Fabricate(:video, title: 'b1')
        b2 =  Fabricate(:video, title: 'b2')
        c =   Fabricate(:video, title: 'c')
        get :search, query: 'b'
        expect(assigns(:videos)).to eq [b1, b2]
      end
    end
  end
  
  context "with unauthenticated user" do
    describe "GET index" do
      it_behaves_like 'requires sign in' do
        let(:action) { get :index }
      end
    end

    describe "GET show" do
      it_behaves_like 'requires sign in' do
        let(:action) { get :show, id: 0 }
      end
    end

    describe "GET search" do
      it_behaves_like 'requires sign in' do
        let(:action) { get :search, query: nil }
      end
    end
  end
end
