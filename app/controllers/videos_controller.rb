class VideosController < ApplicationController

  def index
    @categories = Category.joins(:videos).sorted.uniq
  end

  def show
    @video = Video.find(params[:id])
  end

end
