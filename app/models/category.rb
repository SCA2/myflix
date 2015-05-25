class Category < ActiveRecord::Base
  has_many :videos
  default_scope { order(:name) }
end