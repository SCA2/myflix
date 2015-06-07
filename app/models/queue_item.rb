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

  def rating=(rating)
    if rating
      return review.update(rating: rating)
    else
      return create(:review, body: "Coming soon!", rating: rating)
    end
  end

  def review
    review = Review.find_by(user_id: user.id, video_id: video.id)
  end

end