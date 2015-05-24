class AddTitleToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :title, :string
    add_column :videos, :description, :string
    add_column :videos, :small_cover_url, :string
    add_column :videos, :large_cover_url, :string
  end
end
