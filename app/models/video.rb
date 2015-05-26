class Video < ActiveRecord::Base
  belongs_to :category
  default_scope { order(:title) }
  validates :title, :description, presence: true
end