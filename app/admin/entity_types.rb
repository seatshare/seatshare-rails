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
      EntityType.find_by_id(
        resource.id
      ).entities.order_by_name.collect do |entity|
        li auto_link(entity)
      end
    end
  end

end
