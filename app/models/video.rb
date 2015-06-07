class Video < ActiveRecord::Base
  belongs_to  :category
  has_many    :reviews, -> { order(created_at: :desc) }

  scope :sorted, -> { order(:title) }
  validates :title, :description, presence: true

  def self.search_by_title(query)
    return [] if query.blank?
    where("title ILIKE ?", "%#{query}%").all.sorted
  end
end