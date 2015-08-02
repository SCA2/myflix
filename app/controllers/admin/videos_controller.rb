class Admin::VideosController < ApplicationController

  before_action :authorize
  before_action :require_admin

  def new
    @video = Video.new
  end

  def index
    @videos = Video.all
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "#{@video.title} created!"
      redirect_to new_admin_video_path
    else
      flash[:error] = "Can't create that video!"
      render :new
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :category_id, :small_cover, :large_cover, :video_url)
  end

  def require_admin
    unless current_user.admin?
      flash[:error] = "Sorry, admins only"
      redirect_to home_path
    end
  end
end