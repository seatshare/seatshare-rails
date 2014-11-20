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
      end
    end
  end

end
