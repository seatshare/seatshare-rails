class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :groups
  has_many :tickets
  has_many :user_aliases
  
  validates :first_name, :last_name, :presence => true

  after_create :send_welcome_email

  def initialize(attributes={})
    attr_with_defaults = {
      :status => 1,
    }.merge(attributes)
    super(attr_with_defaults)
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def gravatar(dimensions='30x30')
    require 'digest/md5'
    email_address = self.email.downcase
    hash = Digest::MD5.hexdigest(email_address)
    "https://www.gravatar.com/avatar/#{hash}?s=#{dimensions}&d=mm"
  end

  def newsletter_signup
  end

  def self.get_users_by_group_id(group_id=nil, role=nil)
    user_users = GroupUser.where("group_id = #{group_id}")
    users = Array.new
    user_users.map do |user_group|
      user = User.find(user_group.user_id)
      next if !role.nil? && user_group.role != role
      next if user.status != 1
      users.push user
    end
    users
  end

  private

  def send_welcome_email
    WelcomeEmail.welcome(self).deliver
  end

end
