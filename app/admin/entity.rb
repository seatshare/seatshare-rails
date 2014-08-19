ActiveAdmin.register Entity do

  permit_params :entity_name, :entity_type, :import_key, :status

  filter :entity_name
  filter :entity_type
  filter :import_key
  filter :status

  index do
    selectable_column
    id_column
    column :entity_name
    column :status
    column :import_key
    column :entity_type
    actions
  end

  sidebar 'Entity Groups', :only => :show do
    ul do
      Entity.find(resource.id).groups.order_by_name.collect do |group|
        li auto_link(group)
      end
    end
  end

end