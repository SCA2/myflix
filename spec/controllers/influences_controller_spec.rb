require 'spec_helper'

describe InfluencesController do
  context "with guest user" do
    describe "GET index" do
      it_behaves_like "requires sign in" do
        let(:action) { get :index }
      end
    end

    describe "POST create" do
      it_behaves_like "requires sign in" do
        let(:action) { post :create }
      end
    end

    describe "DELETE destroy" do
      it_behaves_like "requires sign in" do
        let(:action) { delete :destroy, id: 0 }
      end
    end
  end

  context "with signed in user" do

    before        { set_current_user }
    let(:user)    { controller.current_user }
    let(:leader)  { Fabricate(:user) }

    describe "GET index" do
      it "assigns current_user.influences to @influences" do
        get :index
        expect(assigns(:influences)).to eq user.influences
      end
    end

    describe "POST create" do
      it "adds influence of leader to user.leaders" do
        post :create, id: leader.id
        expect(user.leaders).to eq [leader]
      end
    end

    describe "DELETE destroy" do
      it "deletes influence of leader from user.leaders" do
        user.influences.create!(leader_id: leader.id)
        delete :destroy, id: user.influences.last
        expect(user.leaders).to eq []
      end
    end
  end
end