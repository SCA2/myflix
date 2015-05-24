class Video < ActiveRecord::Base
  validates :title, :description, :small_cover_url, :large_cover_url
end