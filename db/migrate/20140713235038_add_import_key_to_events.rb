class AddImportKeyToEvents < ActiveRecord::Migration
  def self.up
    change_table(:events) do |t|
      t.string :import_key, null: false, default: ""
    end
    add_index :events, :import_key, unique: true
  end

  def self.down
    remove_column :events, :import_key
    remove_index :events, :import_key
  end
end
