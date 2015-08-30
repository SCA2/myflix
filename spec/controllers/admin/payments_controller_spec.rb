require 'spec_helper'

describe Admin::PaymentsController do
  describe 'GET index' do
    it_behaves_like 'requires sign in' do
      let(:action) { get :index }
    end

    it_behaves_like 'requires admin' do
      let(:action) { get :index }
    end
  end
end