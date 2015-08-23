require 'spec_helper'

feature 'admin views payments' do
  
  let(:user)    { Fabricate(:user) }
  let!(:payment) { Fabricate(:payment, user: user) }

  scenario 'logged in admin can view payments' do
    sign_in_admin
    visit admin_payments_path
    expect(page).to have_content user.name
    expect(page).to have_content user.email
    expect(page).to have_content payment.amount
    expect(page).to have_content payment.reference_id
  end

  scenario 'logged in user cannot view payments' do
    sign_in_user
    visit admin_payments_path
    expect(page).to have_content "Sorry, admins only"
    expect(page).not_to have_content payment.reference_id
  end
end