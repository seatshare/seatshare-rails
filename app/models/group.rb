##
# Group model
class Group < ActiveRecord::Base
  belongs_to :entity
  belongs_to :creator, class_name: 'User'

  has_many :memberships
  has_many :members, through: :memberships, source: :user
  has_many :events, through: :entity

  validates :entity_id, :group_name, :creator_id, presence: true
  validates_uniqueness_of :group_name, scope: :creator_id,
                                       conditions: -> { where(status: 1) }
  before_save :clean_invitation_code

  has_attached_file(
    :avatar,
    styles: { medium: '300x300>', thumb: '100x100>' },
    default_url: ':placeholder_group',
    storage: :s3,
    s3_protocol: :https,
    s3_credentials: {
      bucket: ENV['SEATSHARE_S3_BUCKET'],
      access_key_id: ENV['SEATSHARE_S3_KEY'],
      secret_access_key: ENV['SEATSHARE_S3_SECRET']
    },
    url: ':s3_alias_url',
    s3_host_alias: ENV['SEATSHARE_S3_PUBLIC'].gsub(%r{https?://}, ''),
    path: ':class-avatars/:id-:style-:hash.:extension',
    hash_secret: 'obfusticateOurAvatarUrlsPlz'
  )

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  scope :order_by_name, -> { order('LOWER(group_name) ASC') }
  scope :active, -> { where('status = 1') }

  ##
  # New group object
  # - attributes: object attributes
  def initialize(attributes = {})
    attr_with_defaults = {
      status: 1,
      invitation_code: generate_invite_code(10)
    }.merge(attributes)
    super(attr_with_defaults)
  end

  ##
  # Display name for group
  def display_name
    "#{group_name}"
  end

  ##
  # List of administrators for group
  def administrators
    members.where(memberships: { role: 'admin' })
  end

  ##
  # See if user is group member
  # - user: User object
  def member?(user = nil)
    membership = Membership.where(
      "group_id = #{id} AND user_id = #{user.id}"
    ).first
    return false if membership.nil?
    membership.user_id == user.id
  end

  ##
  # See if user is group admin
  # - user: User object
  def admin?(user = nil)
    membership = Membership.where(
      "group_id = #{id} AND user_id = #{user.id} AND role = 'admin'"
    ).first
    return false if membership.nil?
    membership.user_id == user.id
  end

  ##
  # Join a user to a group with a role
  # - user: User object
  # - role: string of role
  def join_group(user = nil, role = nil)
    role = 'member' if role != 'admin'
    fail 'NotValidGroup' if id.nil?
    fail 'AlreadyMember' if member?(user)
    user_group = Membership.new(
      user_id: user.id,
      group_id: id,
      role: role
    )
    user_group.save!
    user_group
  end

  ##
  # Leave a group
  # - user: User object
  def leave_group(user = nil)
    membership = Membership.where(
      "user_id = #{user.id} AND group_id = #{id}"
    ).first
    fail 'AdminUserCannotLeave' if membership.role == 'admin'

    Ticket.where("group_id = #{id} AND owner_id = #{user.id}").delete_all
    Ticket.where("group_id = #{id} AND user_id = #{user.id}").each(&:unassign)

    ActiveRecord::Base.connection.execute(
      "DELETE FROM memberships WHERE group_id = #{id} AND user_id = #{user.id}"
    )
  end

  ##
  # Deactivate Group
  def deactivate
    self.status = 0
    save!
  end

  ##
  # Join by invitation code
  # - invitation_code: String
  def self.join_with_invitation_code(invitation_code = nil, user = nil)
    return false if invitation_code.nil? || user.nil?

    # Start by attempting to using a GroupInvite
    invitation = GroupInvitation.get_by_invitation_code(invitation_code)
    unless invitation.blank?
      invitation.group.join_group(user, 'member')
      invitation.use_invitation
      return invitation.group
    end

    # If that didn't work, use a group.invitation_code
    group = find_by_invitation_code(invitation_code)
    unless group.nil?
      group.join_group(user, 'member')
      return group
    end

    false
  end

  private

  ##
  # Generate an invitation code if invitation code empty
  def clean_invitation_code
    self.invitation_code = generate_invite_code(10) if invitation_code.blank?
  end

  ##
  # Generate a generic invitation code for group
  # - size: integer of generated string length
  def generate_invite_code(size = 10)
    charset = %w(2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z)
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end
end
