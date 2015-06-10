require 'spec_helper'

feature 'user signs in' do
  
  let!(:user) { Fabricate(:user) }
  
  scenario 'with existing username' do
    sign_in_user(user)
  end
end

