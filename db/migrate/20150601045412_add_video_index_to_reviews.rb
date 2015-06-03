class AddVideoIndexToReviews < ActiveRecord::Migration
  def change
    add_index :reviews, :video_id
  end
end
