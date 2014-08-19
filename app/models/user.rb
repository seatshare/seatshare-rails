class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :groups
  has_many :tickets
  has_many :user_aliases
  has_many :group_users
  has_many :groups, through: :group_users

  validates :first_name, :last_name, :email, :presence => true

  scope :order_by_name, -> { order('LOWER(last_name) ASC, LOWER(first_name) ASC') }

  attr_accessor :newsletter_signup
  attr_accessor :invite_code

  def active_for_authentication?
    super && status === 1
  end

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

end
