ActiveAdmin.register Entity do

  permit_params :entity_name, :entity_type_id, :import_key, :status

  filter :entity_name
  filter :entity_type
  filter :import_key
  filter :status

  index do
    selectable_column
    id_column
    column :entity_name
    column :status do |entity|
      if entity.status == 1
        status_tag('active', :ok)
      else
        status_tag('inactive')
      end
    end
    column :groups do |entity|
      entity.groups.count
    end
    column :import_key
    column :entity_type
    actions
  end

  show do
    attributes_table do
      row :entity_name
      row :status do |entity|
        if entity.status == 1
          status_tag('active', :ok)
        else
          status_tag('inactive')
        end
      end
      row :import_key
      row :entity_type
    end

    panel "Events" do
      table_for resource.events.by_date do |event|
        column :display_name do |e|
          auto_link(e, e.event_name)
        end
        column :description
        column :start_time do |e|
          e.date_time
        end
        column :entity
        column :import_key
      end
    end

    panel "Tickets" do
      table_for resource.tickets.by_date do |ticket|
        column :display_name do |t|
          auto_link(t, t.display_name)
        end
        column :event do |t|
          auto_link(t.event, t.event.display_name)
        end
        column :group do |t|
          auto_link(t.group, t.group.display_name)
        end
        column :owner
        column :user
        column :alias
        column :cost do |t|
          number_to_currency t.cost
        end
      end
    end
  end

  sidebar 'Entity Groups', only: :show do
    ul do
      Entity.find(resource.id).groups.by_name.collect do |group|
        li auto_link(group)
      end
    end
  end
end
