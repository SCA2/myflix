shared_examples 'requires sign in' do
  it 'redirects to sign_in_path' do
    action
    expect(response).to redirect_to sign_in_path
  end

end

shared_examples 'already signed in' do
  it 'redirects to home path with notice' do
    action
    expect(response).to redirect_to home_path
    expect(flash[:notice]).to be_present
  end
end