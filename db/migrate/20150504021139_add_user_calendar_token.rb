class AddUserCalendarToken < ActiveRecord::Migration
  def self.up
    add_column :users, :calendar_token, :string
    User.find_each do |user|
      begin
        user.update_attributes(
          calendar_token: SecureRandom.urlsafe_base64(nil, false)
        )
      rescue
      end
    end
  end

  def self.down
    remove_column :users, :calendar_token
  end
end
