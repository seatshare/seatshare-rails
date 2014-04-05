class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :entity_id       # entities.id
      t.string :group_name
      t.integer :creator_id      # users.id
      t.string :invitation_code
      t.integer :status
      t.timestamps
    end
    add_index :groups, :entity_id
    add_index :groups, :creator_id
    add_index :groups, :invitation_code, :unique => true
  end
end
