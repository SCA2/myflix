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
  it 'generates a token' do
    object.generate_token(column)
    expect(object[column]).to be_present
  end

  it 'does not save token' do
    object.generate_token(column)
    expect(object.reload[column]).to be_nil
  end

  it 'guarantees token is unique' do
    object.generate_token(column)
    token_1 = object[column]
    object.generate_token(column)
    token_2 = object[column]
    expect(token_1).to_not eq(token_2)
  end
end
