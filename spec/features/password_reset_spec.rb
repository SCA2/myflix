require 'spec_helper'

feature 'password reset' do
  
  let!(:user) { Fabricate(:user) }
  
  scenario 'known user clicks forgot password link' do
    visit sign_in_path
    click_link "password"
    expect(page.current_path).to eq "/passwords/new"
    fill_in "email", with: user.email
    click_button "Send"
    expect(page.current_path).to eq "/passwords"
    expect(page).to have_content "instructions to reset"
    expect(last_email.to).to include user.email
    visit edit_password_url(id: user.reload.password_reset_token)
    expect(page).to have_content "Reset Your Password"
    fill_in "password", with: user.password
    click_button "Reset"
    expect(page.current_path).to eq "/sign_in"
    expect(page).to have_content "updated"
  end
end

