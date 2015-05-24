class VideosController < ApplicationController

  before_action :test_environment
  before_action :set_video, except: [:index]
  
  layout "application"

  def index
    @videos = Video.all
  end

  def show
  end

  private

  def set_video
    @video = Video.find(params[:id])
  end

  def test_environment
    redirect_to :root if Rails.env.production?
  end

end
