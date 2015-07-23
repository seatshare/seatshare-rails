class MoveProfileFieldsToUser < ActiveRecord::Migration
  class User < ActiveRecord::Base
    has_one :profile
  end

  class Profile < ActiveRecord::Base
    belongs_to :user
  end

  def up
    change_table :users do |t|
      t.text     :bio
      t.string   :location
      t.string   :mobile
      t.boolean  :sms_notify
    end

    Profile.joins(:user).find_each do |profile|
      begin
        profile.user.update_attributes(
          bio: profile.bio,
          location: profile.location,
          mobile: profile.mobile,
          sms_notify: profile.sms_notify
        )
      rescue
      end
    end

     drop_table :profiles
  end

  def down
    create_table :profiles do |t|
      t.integer :user_id
      t.text    :bio
      t.string  :location
      t.string  :mobile
      t.timestamps
    end

    User.find_each do |user|
      Profile.create(
        user: user,
        bio: user.bio,
        location: user.location,
        mobile: user.mobile,
        sms_notify: user.sms_notify
      )
    end

    change_table :users do |t|
      t.remove :bio
      t.remove :location
      t.remove :mobile
      t.remove :sms_notify
    end
  end
end
