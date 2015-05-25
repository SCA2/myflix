class VideosController < ApplicationController

  def index
    @categories = Category.joins(:videos).uniq
  end

  def show
    @video = Video.find(params[:id])
  end

end
