ActiveAdmin.register UserAlias do

  menu parent: 'Users'

  index do
    selectable_column
    id_column
    column :display_name
    column :user
    column :created_at
    column :updated_at
    actions
  end

end
