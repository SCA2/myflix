class VideosController < ApplicationController

  def index
    @categories = Category.joins(:videos).order(:name).distinct
  end

  def show
    @video = Video.find(params[:id])
  end

end
