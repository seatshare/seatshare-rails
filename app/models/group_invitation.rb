##
# Group Invitation model
class GroupInvitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :email, :user_id, :group_id, :invitation_code, presence: true

  scope :accepted, -> { where(status: false) }
  attr_accessor :message

  ##
  # New group invitation object
  # - attributes: attributes for object
  def initialize(attributes = {})
    attr_with_defaults = {
      status: true,
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
    invitation = GroupInvitation.find_by(invitation_code: invitation_code)
    invitation
  end

  ##
  # Mark invitation as used
  def use_invitation
    raise 'InvitationAlreadyUsed' unless status?
    self.status = false
    save!
  end

  private

  ##
  # Generate a group invitation code
  def generate_invite_code(size = 10)
    charset = %w(2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z)
    (0...size).map { charset.to_a[rand(charset.size)] }.join
  end
end
