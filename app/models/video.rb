class Video < ActiveRecord::Base
  belongs_to :category
  scope :sorted, -> { order(:title) }
  validates :title, :description, presence: true

  def self.search_by_title(title)
    self.where("title ILIKE ?", "%#{title}%").all.sorted
  end
end