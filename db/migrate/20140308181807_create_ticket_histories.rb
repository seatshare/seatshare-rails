class CreateTicketHistories < ActiveRecord::Migration
  def change
    create_table :ticket_histories do |t|
      t.integer :ticket_id    # tickets.id
      t.integer :group_id     # groups.id
      t.integer :event_id     # events.id
      t.integer :user_id      # users.id
      t.text :entry
      t.timestamps
    end
  end
end
