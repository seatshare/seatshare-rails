ActiveAdmin.register Event do

  index do
    selectable_column
    id_column
    column :event_name
    column :description
    column :start_time do |event|
      event.date_time
    end
    column :tickets do |event|
      link_to event.tickets.count, admin_tickets_path(q: { event_id_eq: event.id })
    end
    column :entity
    column :import_key
    actions
  end

  filter :entity
  filter :event_name
  filter :description
  filter :start_time
  filter :import_key

  show do
    attributes_table do
      row :id
      row :event_name
      row :entity
      row :description
      row :start_time
      row :date_tba
      row :time_tba
      row :created_at
      row :updated_at
      row :import_key
    end

    panel "Tickets" do
      table_for resource.tickets do |ticket|
        column :display_name do |t|
          auto_link(t, t.display_name)
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

end
