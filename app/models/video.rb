class Video < ActiveRecord::Base
  belongs_to :category
  default_scope { order(:title) }
end