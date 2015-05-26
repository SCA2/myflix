class Video < ActiveRecord::Base
  belongs_to :category
  scope :sorted, -> { order(:title) }
  validates :title, :description, presence: true
end