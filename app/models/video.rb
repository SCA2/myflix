class Video < ActiveRecord::Base
  belongs_to  :category
  has_many    :reviews, -> { order(created_at: :desc) }

  scope :sorted, -> { order(:title) }
  validates :title, :description, :category, presence: true

  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  def self.search_by_title(query)
    return [] if query.blank?
    where("title ILIKE ?", "%#{query}%").all.sorted
  end
end