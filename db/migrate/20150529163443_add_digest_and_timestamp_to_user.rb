class AddDigestAndTimestampToUser < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_timestamps(:users)
  end
end
