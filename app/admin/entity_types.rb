ActiveAdmin.register EntityType do

  menu parent: 'Entities'

  permit_params :entity_type_name, :entity_type_abbreviation, :sort

  filter :entity_type_name
  filter :entity_type_abbreviation

  index do
    selectable_column
    id_column
    column :entity_type_name
    column :entity_type_abbreviation
    column :sort
    actions
  end

  sidebar 'Entities', only: :show do
    ul do
      Entity.where(
        "entity_type_id = #{resource.id}"
      ).order_by_name.collect do |entity|
        li auto_link(entity)
      end
    end
  end

end
