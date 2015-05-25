class AddCategoryIDtoVideos < ActiveRecord::Migration
  def change
    add_column :videos, :category_id, :integer
    add_index :videos, :category_id
  end
end
