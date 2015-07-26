class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :name
      t.string :email
      t.text :message
      t.string :invitation_token
      t.datetime :invitation_sent_at
      t.belongs_to :user, index: true
    end
  end
end
