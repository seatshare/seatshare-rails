class AddIdToMembership < ActiveRecord::Migration
  def change
    add_column :memberships, :id, :primary_key
  end
end
