class Video < ActiveRecord::Base
  validate :title, :description, :small_cover_url, :large_cover_url
end