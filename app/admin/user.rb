ActiveAdmin.register User do
  permit_params :first_name, :last_name, :email, :password, :password_confirmation, :status, :timezone, :bio, :location, :mobile, :sms_notify

  index do
    selectable_column
    id_column
    column :display_name
    column :email
    column :status do |u|
      if u.status?
        status_tag('active', :ok)
      else
        status_tag('inactive')
      end
    end
    column :groups do |u|
      u.groups.active.count
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
      f.input :bio
      f.input :location
      f.input :mobile
      f.input :sms_notify, :label => 'Notify SMS'
    end
    f.actions
  end

  batch_action :deactivate do |ids|
    User.find(ids).each do |user|
      user.status = 0
      user.save!
    end
    redirect_to collection_path, alert: 'User(s) deactivated.'
  end

  batch_action :activate do |ids|
    User.find(ids).each do |user|
      user.status = 1
      user.save!
    end
    redirect_to collection_path, alert: 'User(s) activated.'
  end

  sidebar 'User Groups', only: :show do
    ul do
      User.find(resource.id).groups.by_name.collect do |group|
        li auto_link(group)
        ul do
          group.memberships.each do |m|
            next if m.user_id != user.id
            if m.weekly_reminder?
              li status_tag('Weekly Reminder', :ok)
            else
              li status_tag('Weekly Reminder')
            end
            if m.daily_reminder?
              li status_tag('Daily Reminder', :ok)
            else
              li status_tag('Daily Reminder')
            end
            if m.mine_only?
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
