class VideosController < ApplicationController

  include ApplicationHelper

  before_action :test_environment
  
  def index
    @categories = Category.joins(:videos).order(:name).distinct
  end

  def show
    @video = Video.find(params[:id])
  end

end
