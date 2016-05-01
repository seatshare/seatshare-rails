class ChangeIntColumnsToBoolean < ActiveRecord::Migration
  def self.up
    # Create new temporary columns
    add_column :events, :date_tba_tmp, :boolean, default: false
    add_column :events, :time_tba_tmp, :boolean, default: false
    add_column :entities, :status_tmp, :boolean, default: false
    add_column :group_invitations, :status_tmp, :boolean, default: false
    add_column :groups, :status_tmp, :boolean, default: false
    add_column :memberships, :daily_reminder_tmp, :boolean, default: false
    add_column :memberships, :weekly_reminder_tmp, :boolean, default: false
    add_column :memberships, :mine_only_tmp, :boolean, default: false
    add_column :users, :status_tmp, :boolean, default: false

    # make the new column available to model methods
    Event.reset_column_information
    Entity.reset_column_information
    GroupInvitation.reset_column_information
    Group.reset_column_information
    Membership.reset_column_information
    User.reset_column_information

    # populate the data in the new column
    Event.where(:date_tba => 1).update_all(:date_tba_tmp =>true)
    Event.where(:time_tba => 1).update_all(:time_tba_tmp =>true)
    Entity.where(:status => 1).update_all(:status_tmp =>true)
    GroupInvitation.where(:status => 1).update_all(:status_tmp =>true)
    Group.where(:status => 1).update_all(:status_tmp =>true)
    Membership.where(:daily_reminder => 1).update_all(:daily_reminder_tmp =>true)
    Membership.where(:weekly_reminder => 1).update_all(:weekly_reminder_tmp =>true)
    Membership.where(:mine_only => 1).update_all(:mine_only_tmp =>true)
    User.where(:status => 1).update_all(:status_tmp =>true)

    # Remove existing column
    remove_column :events, :date_tba
    remove_column :events, :time_tba
    remove_column :entities, :status
    remove_column :group_invitations, :status
    remove_column :groups, :status
    remove_column :memberships, :daily_reminder
    remove_column :memberships, :weekly_reminder
    remove_column :memberships, :mine_only
    remove_column :users, :status

    # Rename new column
    rename_column :events, :date_tba_tmp, :date_tba
    rename_column :events, :time_tba_tmp, :time_tba
    rename_column :entities, :status_tmp, :status
    rename_column :group_invitations, :status_tmp, :status
    rename_column :groups, :status_tmp, :status
    rename_column :memberships, :daily_reminder_tmp, :daily_reminder
    rename_column :memberships, :weekly_reminder_tmp, :weekly_reminder
    rename_column :memberships, :mine_only_tmp, :mine_only
    rename_column :users, :status_tmp, :status
  end

  def self.down
    # Create new temporary columns
    add_column :events, :date_tba_tmp, :integer, default: 0
    add_column :events, :time_tba_tmp, :integer, default: 0
    add_column :entities, :status_tmp, :integer, default: 0
    add_column :group_invitations, :status_tmp, :integer, default: 0
    add_column :groups, :status_tmp, :integer, default: 0
    add_column :memberships, :daily_reminder_tmp, :integer, default: 0
    add_column :memberships, :weekly_reminder_tmp, :integer, default: 0
    add_column :memberships, :mine_only_tmp, :integer, default: 0
    add_column :users, :status_tmp, :integer, default: 0

    # make the new column available to model methods
    Event.reset_column_information
    Entity.reset_column_information
    GroupInvitation.reset_column_information
    Group.reset_column_information
    Membership.reset_column_information
    User.reset_column_information

    # populate the data in the new column
    Event.where(:date_tba => true).update_all(:date_tba_tmp => 1)
    Event.where(:time_tba => true).update_all(:time_tba_tmp => 1)
    Entity.where(:status => true).update_all(:status_tmp => 1)
    GroupInvitation.where(:status => true).update_all(:status_tmp => 1)
    Group.where(:status => true).update_all(:status_tmp => 1)
    Membership.where(:daily_reminder => true).update_all(:daily_reminder_tmp => 1)
    Membership.where(:weekly_reminder => true).update_all(:weekly_reminder_tmp => 1)
    Membership.where(:mine_only => true).update_all(:mine_only_tmp => 1)
    User.where(:status => true).update_all(:status_tmp => 1)

    # Remove existing column
    remove_column :events, :date_tba
    remove_column :events, :time_tba
    remove_column :entities, :status
    remove_column :group_invitations, :status
    remove_column :groups, :status
    remove_column :memberships, :daily_reminder
    remove_column :memberships, :weekly_reminder
    remove_column :memberships, :mine_only
    remove_column :users, :status

    # Rename new column
    rename_column :events, :date_tba_tmp, :date_tba
    rename_column :events, :time_tba_tmp, :time_tba
    rename_column :entities, :status_tmp, :status
    rename_column :group_invitations, :status_tmp, :status
    rename_column :groups, :status_tmp, :status
    rename_column :memberships, :daily_reminder_tmp, :daily_reminder
    rename_column :memberships, :weekly_reminder_tmp, :weekly_reminder
    rename_column :memberships, :mine_only_tmp, :mine_only
    rename_column :users, :status_tmp, :status
  end

end
