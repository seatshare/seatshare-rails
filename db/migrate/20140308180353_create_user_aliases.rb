class CreateUserAliases < ActiveRecord::Migration
  def change
    create_table :user_aliases do |t|
      t.string :first_name
      t.string :last_name
      t.integer :user_id     # users.id
      t.timestamps
    end
  end
end
