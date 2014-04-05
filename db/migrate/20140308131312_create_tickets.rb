class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.integer :group_id   # groups.id
      t.integer :event_id   # events.id
      t.integer :owner_id   # users.id
      t.integer :user_id    # users.id
      t.integer :alias_id   # user_aliases.id
      t.string :section
      t.string :row
      t.string :seat
      t.decimal :cost
      t.text :note
      t.timestamps
    end
    add_index :tickets, :group_id
    add_index :tickets, :event_id
    add_index :tickets, :owner_id
    add_index :tickets, :user_id
    add_index :tickets, :alias_id
  end
end
