class ReviewsController < ApplicationController

  before_action :authorize

  def create
    @video = Video.find(params[:video_id])
    review = Review.new(review_params)
    if review.save
      redirect_to @video
    else
      @reviews = @video.reviews
      render 'videos/show'
    end
  end

  private

  def review_params
    p = params.require(:review).permit(:rating, :body)
    p.merge(user: current_user, video: @video)
  end
end