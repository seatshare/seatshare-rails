class AddSmsNotifyToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :sms_notify, :boolean
  end
end
