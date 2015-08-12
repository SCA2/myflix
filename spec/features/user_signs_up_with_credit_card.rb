require 'spec_helper'

feature 'user signs up with credit card', vcr: true, js: true do

  background { visit register_path }

  describe 'valid user info' do

    let(:new_user) { Fabricate.attributes_for(:user) }

    scenario 'valid credit card number' do
      user_signs_up('4242424242424242')
      expect(page).to have_content "Welcome, #{new_user[:name]}"
    end

    scenario 'invalid credit card number' do
      user_signs_up('4000000000000069')
      expect(page).to have_content "Your card has expired"
    end
    
    scenario 'card declined' do
      user_signs_up('4000000000000002')
      expect(page).to have_content "Your card was declined"
    end
  end

  describe 'invalid user info' do

    let(:new_user) { Fabricate.attributes_for(:user, email: nil) }

    scenario 'valid credit card number' do
      user_signs_up('4242424242424242')
      expect(page).to have_content "Sorry, can't complete sign up"
    end

    scenario 'invalid credit card number' do
      user_signs_up('4000000000000069')
      expect(page).to have_content "Sorry, can't complete sign up"
    end
    
    scenario 'card declined' do
      user_signs_up('4000000000000002')
      expect(page).to have_content "Sorry, can't complete sign up"
    end
  end
end

def user_signs_up(card_number)
  fill_in "user_email", with: new_user[:email]
  fill_in "user_name", with: new_user[:name]
  fill_in "user_password", with: new_user[:password]
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code", with: '123'
  select "7 - July", from: "date_month"
  select "2016", from: "date_year"
  click_button "Sign Up"
end