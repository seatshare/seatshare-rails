ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :status

  index do
    selectable_column
    id_column
    column :display_name
    column :email
    column :status do |entity|
      if entity.status == 1
        status_tag('active', :ok)
      else
        status_tag('inactive')
      end
    end
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :first_name
  filter :last_name
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :status
    end
    f.actions
  end
 
  sidebar 'User Groups', :only => :show do
    ul do
      User.find(resource.id).groups.order_by_name.collect do |group|
        li auto_link(group)
      end
    end
  end

end
