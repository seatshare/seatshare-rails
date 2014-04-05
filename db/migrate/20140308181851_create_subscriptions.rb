class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :group_id     # groups.id
      t.string  :customer_id  # Stripe identifier
      t.integer :status
      t.timestamps
    end
  end
end
