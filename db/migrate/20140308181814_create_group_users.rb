class CreateGroupUsers < ActiveRecord::Migration

  def change
    create_table :group_users, :id => false do |t|
      t.integer :group_id   # groups.id
      t.integer :user_id    # users.id
      t.string :role        # [member, admin]
      t.integer :daily_reminder
      t.integer :weekly_reminder
      t.timestamps
    end

    add_index :group_users, [:group_id, :user_id]

  end

end
