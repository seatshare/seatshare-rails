ActiveAdmin.register GroupInvitation do

  menu parent: 'Groups'

  index do
    selectable_column
    id_column
    column :email
    column :status do |i|
      if i.status?
        status_tag('pending', class: 'no')
      else
        status_tag('accepted', class: 'yes')
      end
    end
    column :invitation_code
    column :user
    column :group
    column :created_at
    actions
  end

end
