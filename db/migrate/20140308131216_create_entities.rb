class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
      t.string :entity_name
      t.integer :status, :default => 0, :null => false
      t.timestamps
    end

    add_index(:entities, [:entity_name, :entity_type], unique: true)
  end
end
