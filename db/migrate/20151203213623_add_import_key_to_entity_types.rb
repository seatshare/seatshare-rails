class AddImportKeyToEntityTypes < ActiveRecord::Migration
  def self.up
    add_column :entity_types, :import_key, :string
    EntityType.find_each do |et|
      et.update_attributes(import_key: et.entity_type_abbreviation.downcase)
    end
    add_index :entity_types, :import_key, unique: true
  end
  def self.down
    remove_column :entity_types, :import_key
  end
end
