class AddMineOnlyToGroupUsers < ActiveRecord::Migration
  def change
    add_column :group_users, :mine_only, :integer
  end
end
