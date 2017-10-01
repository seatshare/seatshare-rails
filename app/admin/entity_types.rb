ActiveAdmin.register EntityType do

  menu parent: 'Entities'

  permit_params :entity_type_name, :entity_type_abbreviation, :import_key, :sort

  filter :entity_type_name
  filter :entity_type_abbreviation

  index do
    selectable_column
    id_column
    column :entity_type_name
    column :entity_type_abbreviation
    column :entities do |entity_type|
      link_to entity_type.entities.count, admin_entities_path(q: { entity_type_id_eq: entity_type.id })
    end
    column :import_key
    column :sort
    actions
  end

  show do
    attributes_table do
      row :id
      row :entity_type_name
      row :entity_type_abbreviation
      row :sort
      row :import_key
      row :created_at
      row :updated_at
    end

    panel "Entities" do
      table_for resource.entities.by_name do |entity|
        column :display_name do |e|
          auto_link(e, e.entity_name)
        end
        column :status do |e|
          if e.status?
            status_tag('active', class: 'yes')
          else
            status_tag('inactive', class: 'no')
          end
        end
        column :groups do |e|
          link_to e.groups.count, admin_groups_path(q: { entity_id_eq: e.id })
        end
        column :events do |e|
          link_to e.events.count, admin_events_path(q: { entity_id_eq: e.id })
        end
        column :tickets do |e|
          link_to e.tickets.count, admin_tickets_path(q: { entity_id_eq: e.id })
        end
        column :import_key
      end
    end
  end

end
