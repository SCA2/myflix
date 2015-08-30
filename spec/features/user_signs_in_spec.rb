require 'spec_helper'

feature 'user signs in' do

  scenario 'with valid email and password' do
    user = Fabricate(:user)
    sign_in_user(user)
    expect(page).to have_content user.name
  end

  scenario 'with deactivated user' do
    user = Fabricate(:user, active: false)
    sign_in_user(user)
    expect(page).not_to have_content user.name
    expect(page).to have_content "Your account has been suspended!"
  end
end

