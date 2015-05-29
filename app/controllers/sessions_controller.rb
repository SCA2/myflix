class SessionsController < ApplicationController

  def new
  end

  def create
    redirect_to home_path
  end

end