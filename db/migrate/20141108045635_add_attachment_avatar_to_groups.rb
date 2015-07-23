class AddAttachmentAvatarToGroups < ActiveRecord::Migration
  def self.up
    change_table :groups do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :groups, :avatar
  end
end
