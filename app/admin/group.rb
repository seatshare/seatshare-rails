ActiveAdmin.register Group do

  permit_params :group_name, :entity_id, :creator_id, :invitation_code, :status

  index do
    selectable_column
    id_column
    column :group_name
    column :invitation_code
    column :status do |entity|
      if entity.status == 1
        status_tag('active', :ok)
      else
        status_tag('inactive')
      end
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :entity
  filter :creator
  filter :group_name
  filter :invitation_code
  filter :status

  sidebar 'Group Members', only: :show do
    ul do
      Group.find(resource.id).users.order_by_name.collect do |user|
        li auto_link(user)
        ul do
          membership = user.group_users.each do |m|
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
