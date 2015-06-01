require 'spec_helper'

describe VideosController do

  context "with authenticated user" do

    before(:each) do
      user = Fabricate(:user)
      controller.sign_in(user)
    end

    describe "GET index" do
      it "sets @categories variable" do
        c = Fabricate(:category)
        get :index
        expect(assigns(:categories)).to eq [c]
      end
    end

    describe "GET show" do
      let(:v) { Fabricate(:video) }
      it "sets @video variable" do
        get :show, id: v.id
        expect(assigns(:video)).to eq v
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
      it "redirects to sign_in path" do
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end

    describe "GET show" do
      it "redirects to sign_in path" do
        get :show, id: 0
        expect(response).to redirect_to sign_in_path
      end
    end

    describe "GET search" do
      it "redirects to sign_in path" do
        get :search, query: nil
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
