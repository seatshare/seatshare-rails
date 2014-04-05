class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :group_id           # groups.id
      t.integer :user_id            # users.id
      t.integer :reminder_type_id   # [1 => weekly, 2 => daily]
      t.text :entry
      t.timestamps
    end
    add_index :reminders, :user_id
  end
end
