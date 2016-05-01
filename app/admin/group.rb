ActiveAdmin.register Group do

  permit_params :group_name, :entity_id, :creator_id, :invitation_code, :status

  index do
    selectable_column
    id_column
    column :group_name
    column :entity
    column :invitation_code
    column :status do |group|
      if group.status == true
        status_tag('active', :ok)
      else
        status_tag('inactive')
      end
    end
    column :members do |group|
      group.members.count
    end
    column :tickets do |group|
      link_to group.tickets.count, admin_tickets_path(q: { group_id_eq: group.id })
    end
    column :created_at
    actions
  end

  filter :entity
  filter :creator
  filter :group_name
  filter :invitation_code
  filter :status

  show do
    attributes_table do
      row :group_name
      row :status do |group|
        if group.status == true
          status_tag('active', :ok)
        else
          status_tag('inactive')
        end
      end
      row :invitation_code
      row :entity
      row :creator
      row :created_at
      row :updated_at
      row :avatar do |group|
        image_tag group.avatar.url(:thumb)
      end
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

  sidebar 'Group Members', only: :show do
    ul do
      Group.find(resource.id).members.by_name.collect do |user|
        li auto_link(user)
        ul do
          membership = user.memberships.each do |m|
            next if m.group_id != group.id
            if m.weekly_reminder == 1
              li status_tag('Weekly Reminder', :ok)
            else
              li status_tag('Weekly Reminder')
            end
            if m.daily_reminder == 1
              li status_tag('Daily Reminder', :ok)
            else
              li status_tag('Daily Reminder')
            end
            if m.mine_only == 1
              li status_tag('Mine Only', :ok)
            else
              li status_tag('Mine Only')
            end
          end
        end
      end
    end
  end

end
