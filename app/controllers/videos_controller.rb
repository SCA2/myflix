class VideosController < ApplicationController

  before_action :authorize

  def index
    @categories = Category.joins(:videos).sorted.uniq
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @videos = Video.search_by_title(params[:query])
  end

end
