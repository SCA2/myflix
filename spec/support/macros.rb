def set_current_user(user=nil)
  @user = user || Fabricate(:user)
  controller.sign_in(@user)
end