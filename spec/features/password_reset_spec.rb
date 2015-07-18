require 'spec_helper'

feature 'password reset' do
  
  let!(:user) { Fabricate(:user) }
  
  scenario 'known user clicks forgot password link' do
    visit sign_in_path
    click_link "password"
    expect(page.current_path).to eq "/password_forgot"
    fill_in "email", with: user.email
    click_button "Send"
    expect(page.current_path).to eq "/password_email"
    expect(page).to have_content "instructions to reset"
    expect(last_email.to).to include user.email
    visit password_reset_path
    expect(page.current_path).to eq "/password_reset"
    fill_in "password", with: user.password
    click_button "Reset"
    expect(page.current_path).to eq "/sign_in"
  end
end

