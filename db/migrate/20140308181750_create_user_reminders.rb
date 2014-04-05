class CreateUserReminders < ActiveRecord::Migration
  def change
    create_table :user_reminders, :id => false do |t|
      t.integer :group_id           # groups.id
      t.integer :user_id            # users.id
      t.integer :reminder_type_id   # [1 => weekly, 2 => daily]
      t.timestamps
    end
    add_index :user_reminders, [:group_id, :user_id]
  end
end
