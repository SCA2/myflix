class Category < ActiveRecord::Base
  has_many :videos, -> { order(:title) }
  scope :sorted, -> { order(:name) }
  validates :name, presence: true

  def recent_videos  
    v = videos.reorder(created_at: :desc).first(6)
    # binding.pry
  end
end