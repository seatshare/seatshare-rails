class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :entity_id
      t.string :event_name
      t.text :description
      t.datetime :start_time
      t.integer :date_tba
      t.integer :time_tba
      t.timestamps
    end
    add_index :events, :entity_id
  end
end
