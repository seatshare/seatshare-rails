ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :status, :timezone, profile_attributes: [:bio, :location, :mobile]

  index do
    selectable_column
    id_column
    column :display_name
    column :email
    column :status do |u|
      if u.status == 1
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
    f.inputs 'Admin Details' do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :timezone
      f.input :status
      f.inputs do
        f.has_many :profile, allow_destroy: false, new_record: false do |pf|
          pf.input :bio
          pf.input :location
          pf.input :mobile
          pf.input :sms_notify, :label => 'Notify SMS'
        end
      end
    end
    f.actions
  end

  sidebar 'User Groups', only: :show do
    ul do
      User.find(resource.id).groups.order_by_name.collect do |group|
        li auto_link(group)
        ul do
          membership = group.memberships.each do |m|
            next if m.user_id != user.id
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
