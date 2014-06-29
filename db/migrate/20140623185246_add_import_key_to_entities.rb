class AddImportKeyToEntities < ActiveRecord::Migration
  def self.up
    change_table(:entities) do |t|
      t.string :import_key, null: false, default: ""
      t.string :entity_type, null: false, default: ""
      remove_column :entities, :logo
    end
  end

  def self.down
    remove_column :entities, :import_key
    remove_column :entities, :entity_type
    change_table(:entities) do |t|
      t.string :logo
    end
  end
end
