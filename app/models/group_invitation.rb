class GroupInvitation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :email, :user_id, :group_id, :invitation_code, :presence => true

  def initialize(attributes={})
    attr_with_defaults = {
      :status => 1,
      :invitation_code => generate_invite_code
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def display_name
    "#{invitation_code}"
  end

  def self.get_by_invitation_code(invitation_code=nil)
    if invitation_code.length != 10
      raise "InvalidInvitation"
    end
    invitation = GroupInvitation.where("invitation_code = '#{invitation_code}'").first
    if invitation.nil?
      raise "InvalidInvitation"
    end
    return invitation
  end

  def use_invitation
    if self.status === 0
      raise "InvitationAlreadyUsed"
    end
    self.status = 0
    self.save!
  end

  def user
    User.find_by_id(self.user_id)
  end

  def group
    Group.find_by_id(self.group_id)
  end

  private

  def generate_invite_code(size = 10)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

end
