require 'spec_helper'

feature 'invite a friend' do

  before { StripeMock.start }
  after { StripeMock.stop }
  let(:invitation)  { Fabricate.attributes_for(:invitation) }
  let!(:user)       { Fabricate(:user) }
  
  scenario 'signed-in user invites a friend to join' do
    sign_in_user(user)
    invite_a_friend
    verify_invitation_sent
    sign_out_user

    friend_accepts_invitation
    friend_signs_up
    expect_friend_to_follow(user.name)
    sign_out_user

    sign_in_user(user)
    expect_user_to_follow(invitation[:name])
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "invitation_name", with: invitation[:name]
    fill_in "invitation_email", with: invitation[:email]
    fill_in "invitation_message", with: invitation[:message]
    click_button "Send"
  end

  def verify_invitation_sent
    expect(page).to have_content "Invitation sent"
    expect(last_email.to).to include invitation[:email]
  end

  def friend_accepts_invitation
    open_email(invitation[:email])
    current_email.click_link "Join MyFlix"
    expect(page).to have_content "Register"
    expect(page).to have_field('Email Address', with: invitation[:email])
  end

  def friend_signs_up
    fill_in "user_name", with: invitation[:name]
    fill_in "user_password", with: 'password'
    click_button "Sign Up"
    expect(page).to have_content "Welcome, #{invitation[:name]}"
  end

  def expect_friend_to_follow(user_name)
    visit people_path
    expect(page).to have_content user_name
  end

  def expect_user_to_follow(friend_name)
    click_link "People"
    expect(page).to have_content friend_name
  end

end

