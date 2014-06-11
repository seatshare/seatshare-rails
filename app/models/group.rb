class Group < ActiveRecord::Base
  has_many :group_users
  has_many :users, through: :group_users
  has_many :tickets, through: :events
  has_many :events, through: :entities
  has_many :subscriptions
  belongs_to :entities

  validates :entity_id, :group_name, :creator_id, :invitation_code, :presence => true

  def initialize(attributes={})
    attr_with_defaults = {
      :status => 1,
      :invitation_code => generate_invite_code(10)
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def entity
    Entity.find_by_id(self.entity_id)
  end

  def creator
    User.find_by_id(self.creator_id)
  end

  def events
    Event.where("entity_id = #{self.entity.id}")
  end

  def members
    User.get_users_by_group_id(self.id)
  end

  def administrators
    User.get_users_by_group_id(self.id, 'admin')
  end

  def self.get_by_ticket_id(ticket_id=nil)
    ticket = Ticket.find(ticket_id)
    group = Group.find(ticket.group_id)
    return group
  end

  def self.get_groups_by_user_id(user_id=nil)
    user_groups = GroupUser.where("user_id = #{user_id}")
    groups = Array.new
    user_groups.map do |user_group|
      group = Group.find(user_group.group_id)
      if group.status === 1
        groups.push group
      end
    end
    return groups
  end

  def is_member(user=nil)
    group_user = GroupUser.where("group_id = #{self.id} AND user_id = #{user.id}").first
    if group_user.nil?
      return false
    end
    return group_user.user_id == user.id
  end

  def is_admin(user=nil)
    group_user = GroupUser.where("group_id = #{self.id} AND user_id = #{user.id} AND role = 'admin'").first
    if group_user.nil?
      return false
    end
    return group_user.user_id == user.id
  end

  def join_group(user=nil, role=nil)
    if role != 'admin'
      role = 'member'
    end
    if self.id === nil
      return "NotValidGroup"
    end
    user_group = GroupUser.new({
      :user_id => user.id,
      :group_id => self.id,
      :role => role
    })
    user_group.save!
    return user_group
  end

  def leave_group(user=nil)
    group_user = GroupUser.where("user_id = #{user.id} AND group_id = #{self.id}").first
    if group_user.role == 'admin'
      raise "AdminUserCannotLeave"
    end

    Ticket.where("group_id = #{self.id} AND owner_id = #{user.id}").delete_all
    Ticket.where("group_id = #{self.id} AND user_id = #{user.id}").update_all({
      :user_id => 0,
      :alias_id => 0
    })

    ActiveRecord::Base.connection.execute("DELETE FROM group_users WHERE group_id = #{self.id} AND user_id = #{user.id}")

  end


  private

  def generate_invite_code(size = 10)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

end
