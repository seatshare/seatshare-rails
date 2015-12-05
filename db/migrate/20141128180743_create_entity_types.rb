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

    Entity.where(entity_type: 'NHL').update_all(
        entity_type_id: 1
    )
    Entity.where(entity_type: 'MLB').update_all(
      entity_type_id: 2
    )
    Entity.where(entity_type: 'NBA').update_all(
      entity_type_id: 3
    )
    Entity.where(entity_type: 'NFL').update_all(
      entity_type_id: 4
    )
    Entity.where(entity_type: 'MLS').update_all(
      entity_type_id: 5
    )
    Entity.where(entity_type: 'CFL').update_all(
      entity_type_id: 6
    )
    Entity.where(entity_type: 'NCAAF').update_all(
      entity_type_id: 7
    )
    Entity.where(entity_type: 'NCAAMB').update_all(
      entity_type_id: 8
    )
    Entity.where(entity_type: 'WFTDA').update_all(
      entity_type_id: 9
    )
    Entity.where(entity_type: 'NCAAWB').update_all(
      entity_type_id: 10
    )

    remove_column :entities, :entity_type

  end
end
