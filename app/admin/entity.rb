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

end