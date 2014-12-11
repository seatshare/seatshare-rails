##
# Group Invitation model
class GroupInvitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :email, :user_id, :group_id, :invitation_code, presence: true

  scope :accepted, -> { where('status = 0') }
  attr_accessor :message

  ##
  # New group invitation object
  # - attributes: attributes for object
  def initialize(attributes = {})
    attr_with_defaults = {
      status: 1,
      invitation_code: generate_invite_code
    }.merge(attributes)
    super(attr_with_defaults)
  end

  ##
  # Display name for group invitation
  def display_name
    "#{group.group_name}: #{email}"
  end

  ##
  # Retrieve invitation by invitation code
  def self.get_by_invitation_code(invitation_code = nil)
    fail 'InvalidInvitation' if invitation_code.length != 10
    invitation = GroupInvitation.where(
      "invitation_code = '#{invitation_code}'"
    ).first
    fail 'InvalidInvitation' if invitation.nil?
    invitation
  end

  ##
  # Mark invitation as used
  def use_invitation
    fail 'InvitationAlreadyUsed' if status == 0
    self.status = 0
    self.save!
  end

  private

  ##
  # Generate a group invitation code
  def generate_invite_code(size = 10)
    charset = %w(2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z)
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end
end
