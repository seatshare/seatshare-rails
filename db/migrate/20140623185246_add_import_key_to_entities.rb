class AddImportKeyToEntities < ActiveRecord::Migration
  def self.up
    change_table(:entities) do |t|
      t.string :import_key, null: false, default: ""
      t.string :entity_type, null: false, default: ""
    end
    remove_index :entities, :entity_name
    add_index :entities, :import_key, unique: true
    add_index :entities, [:entity_name, :entity_type], unique: true
  end

  def self.down
    remove_index :entities, :import_key
    remove_index :entities, [:entity_name, :entity_type]
    remove_column :entities, :import_key
    remove_column :entities, :entity_type
    add_index :entities, :entity_name
  end
end
