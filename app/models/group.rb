class Group < ActiveRecord::Base
  belongs_to :entity
  belongs_to :creator, :class_name => 'User'

  has_many :group_users
  has_many :users, through: :group_users

  validates :entity_id, :group_name, :creator_id, :presence => true
  before_save :clean_invitation_code

  scope :order_by_name, -> { order('LOWER(group_name) ASC') }
  scope :active, -> { where('status = 1') }

  def initialize(attributes={})
    attr_with_defaults = {
      :status => 1,
      :invitation_code => generate_invite_code(10)
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def display_name
    "#{group_name}"
  end

  def events
    Event.where("entity_id = #{self.entity.id}")
  end

  def administrators
    users.where(group_users: { role: 'admin' })
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

  def clean_invitation_code
    if self.invitation_code.blank?
      self.invitation_code = generate_invite_code(10)
      puts self.invitation_code
    end
  end

  def generate_invite_code(size = 10)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

end
