require 'spec_helper'

feature 'password reset' do
  
  let!(:user) { Fabricate(:user) }
  
  scenario 'known user clicks forgot password link' do
    visit sign_in_path
    click_link "password"
    fill_in "email", with: user.email
    click_button "Send"

    expect(page).to have_content "instructions to reset"
    expect(last_email.to).to include user.email

    open_email(user.email)
    current_email.click_link "Click here"
    expect(page).to have_content "Reset Your Password"

    fill_in "password", with: 'new_password'
    click_button "Reset"
    expect(page).to have_content "updated"

    fill_in "Email", with: user.email
    fill_in "Password", with: 'new_password'
    click_button "Sign in"
    expect(page).to have_content "Welcome, #{user.name}"
  end
end

