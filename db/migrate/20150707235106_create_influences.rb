class CreateInfluences < ActiveRecord::Migration
  def change
    create_table :influences do |t|
      t.belongs_to :user, index: true
      t.belongs_to :leader, index: true
      t.timestamps null: false
    end
  end
end
