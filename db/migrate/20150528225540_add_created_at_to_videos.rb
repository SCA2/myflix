class AddCreatedAtToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :created_at, :datetime
  end
end
