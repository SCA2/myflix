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
    let(:user_2)  { Fabricate(:user) }

    describe "GET index" do
      it "assigns current_user.leader_influences to @influences" do
        get :index
        expect(assigns(:influences)).to eq user.leader_influences
      end
    end

    describe "POST create" do
      it "adds influence of leader to user.leaders" do
        post :create, id: leader.id
        expect(user.leaders).to eq [leader]
      end

      it "can't follow same leader more than once" do
        post :create, id: leader.id
        post :create, id: leader.id
        expect(Influence.count).to eq 1
      end

      it "can't follow yourself" do
        post :create, id: user.id
        expect(Influence.count).to eq 0
      end

      it "redirects to people_path" do
        post :create, id: leader.id
        expect(response).to redirect_to people_path
      end
    end

    describe "DELETE destroy" do
      it "redirects to the people page" do
        user.leader_influences.create!(leader_id: leader.id)
        delete :destroy, id: user.leader_influences.last
        expect(response).to redirect_to people_path
      end
        
      it "deletes influence of leader from user.leaders" do
        user.leader_influences.create!(leader_id: leader.id)
        delete :destroy, id: user.leader_influences.last
        expect(user.leaders).to eq []
      end

      it "only deletes influence belonging to current user" do
        user_2.leader_influences.create!(leader_id: leader.id)
        expect {
          delete :destroy, id: user_2.leader_influences.last
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end