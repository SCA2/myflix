class Category < ActiveRecord::Base
  has_many :videos, -> { order(:title) }
  default_scope { order(:name) }
  validates :name, presence: true
end