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

shared_examples 'tokenable' do
  it 'generates a unique token each time' do
    send_object_1
    # last_token = token
    send_object_2
    expect(token_1).to_not eq(token_2)
  end

  # it 'saves the time the object reset was sent' do
  #   send_object
  #   expect(sent_at).to be_present
  # end

  # it 'delivers email to invitee' do
  #   send_object
  #   expect(last_email.to).to include(object.email)
  # end
end
