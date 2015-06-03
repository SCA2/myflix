class AddReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t| 
      t.string      :author
      t.text        :body
      t.integer     :rating
      t.belongs_to  :video
      t.timestamps
    end
  end
end
