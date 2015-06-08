class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  validates :video, uniqueness: { scope: :user }
  validates :order, presence: true
  validates :order, numericality: { greater_than: 0 }
  validates :order, numericality: { only_integer: true }
  
  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def category_name
    category.name
  end

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update(rating: new_rating, skip_rating_validation: true)
    else
      Review.create(user: user, video: video, skip_body_validation: true, rating: new_rating)
    end
  end

  def review
    @review ||= Review.find_by(user_id: user.id, video_id: video.id)
  end

end