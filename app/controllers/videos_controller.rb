class VideosController < ApplicationController

  before_action :authorize

  def index
    @categories = Category.joins(:videos).sorted.uniq
  end

  def show
    @video = Video.find(params[:id])
    @video = VideoDecorator.decorate(@video)
    @reviews = @video.reviews
  end

  def search
    @videos = Video.search_by_title(params[:query1])
  end

  def advanced_search
    if search_query
      @videos = Video.search(search_query, search_options).records.to_a
    else
      @videos = []
    end
  end

  private

  def search_query
    params[:query2]
  end

  def search_options
    params.permit(:reviews, :rating_from, :rating_to)
  end

end
