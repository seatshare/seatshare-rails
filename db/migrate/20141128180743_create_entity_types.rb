class CreateEntityTypes < ActiveRecord::Migration
  def change
    create_table :entity_types do |t|
      t.string :entity_type_name
      t.string :entity_type_abbreviation
      t.integer :sort
      t.timestamps
    end

    # Migrate old strings to new type IDs
    add_column :entities, :entity_type_id, :integer, default: 0
    remove_column :entities, :entity_type

  end
end
