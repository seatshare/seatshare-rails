ActiveAdmin.register Group do

  permit_params :group_name, :entity_id, :creator_id, :invitation_code, :status

  filter :entity
  filter :creator
  filter :group_name
  filter :invitation_code
  filter :status
 
  sidebar 'Group Members', :only => :show do
    ul do
      Group.find(resource.id).users.order_by_name.collect do |user|
        li auto_link(user)
      end
    end
  end

end
