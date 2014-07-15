class AddImportKeyToEntities < ActiveRecord::Migration
  def self.up
    change_table(:entities) do |t|
      t.string :import_key, null: false, default: ""
      t.string :entity_type, null: false, default: ""
    end
    add_index :entities, :import_key, unique: true
  end

  def self.down
    remove_column :entities, :import_key
    remove_column :entities, :entity_type
    change_table(:entities) do |t|
      t.string :logo
    end
    remove_index :entities, :import_key
  end
end
