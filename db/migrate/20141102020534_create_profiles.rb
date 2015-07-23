class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id    # users.id
      t.text :bio
      t.string :location
      t.string :mobile
      t.timestamps
    end
  end
end
