class RenameGroupUserToMembership < ActiveRecord::Migration
  def change
    rename_table :group_users, :memberships
  end
end
