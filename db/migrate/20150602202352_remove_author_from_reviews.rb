class RemoveAuthorFromReviews < ActiveRecord::Migration
  def change
    remove_column :reviews, :author, :string
  end
end
