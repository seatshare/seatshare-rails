##
# User Alias model
class UserAlias < ActiveRecord::Base
  belongs_to :user

  validates :first_name, :last_name, :user_id, presence: true

  scope :order_by_name, -> { order_by_name }

  ##
  # Display name for user alias
  def display_name
    "#{first_name} #{last_name}"
  end

  ##
  # Handle ticket unassignment on delete
  def destroy
    tickets = Ticket.where("alias_id = #{id}")
    tickets.each do |ticket|
      ticket.alias_id = 0
      ticket.save!
    end
    super
  end

  ##
  # Order user aliases by name
  def self.order_by_name
    order('LOWER(last_name) ASC, LOWER(first_name) ASC')
  end
end
