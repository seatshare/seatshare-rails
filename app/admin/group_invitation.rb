ActiveAdmin.register GroupInvitation do

  menu parent: 'Groups'

  index do
    selectable_column
    id_column
    column :email
    column :status do |i|
      if i.status?
        status_tag('pending')
      else
        status_tag('accepted', :ok)
      end
    end
    column :invitation_code
    column :user
    column :group
    column :created_at
    actions
  end

end
