class CreateTicketFiles < ActiveRecord::Migration
  def change
    create_table :ticket_files do |t|
      t.integer :user_id     # users.id
      t.integer :ticket_id   # tickets.id
      t.string :path
      t.string :file_name
      t.timestamps
    end
    add_index :ticket_files, :ticket_id
  end
end
