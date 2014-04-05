class CreateGroupInvitations < ActiveRecord::Migration
  def change
    create_table :group_invitations do |t|
      t.integer :user_id    # users.id
      t.integer :group_id   # groups.id
      t.string :email
      t.string :invitation_code
      t.integer :status 
      t.timestamps
    end
    add_index :group_invitations, :invitation_code, :unique => true
    add_index :group_invitations, :user_id
    add_index :group_invitations, :group_id
  end
end
