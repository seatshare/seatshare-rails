ActiveAdmin.register Group do

  permit_params :group_name, :entity_id, :creator_id, :invitation_code, :status

  filter :entity
  filter :creator
  filter :group_name
  filter :invitation_code
  filter :status
  
end
