class RenameGroupUserToMembership < ActiveRecord::Migration
  def change
    rename_table :group_users, :memberships
    rename_column :memberships, :user_id, :member_id
  end
end
