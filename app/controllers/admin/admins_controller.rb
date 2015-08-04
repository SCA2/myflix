class Admin::AdminsController < ApplicationController

  before_action :authorize
  before_action :require_admin

  private
  
  def require_admin
    unless current_user.admin?
      flash[:error] = "Sorry, admins only"
      redirect_to home_path
    end
  end

end