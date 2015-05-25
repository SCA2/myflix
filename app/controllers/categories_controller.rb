class CategoriesController < ApplicationController

  include ApplicationHelper

  before_action :test_environment

  def show
    @category = Category.find(params[:id])
  end

end