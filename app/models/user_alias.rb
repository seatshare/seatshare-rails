class UserAlias < ActiveRecord::Base
  belongs_to :user

  validates :first_name, :last_name, :user_id, :presence => true

  scope :order_by_name, -> { order('LOWER(last_name) ASC, LOWER(first_name) ASC') }

  def display_name
    "#{self.first_name} #{self.last_name}"
  end

  def destroy
    tickets = Ticket.where("alias_id = #{self.id}")
    for ticket in tickets
      ticket.alias_id = 0
      ticket.save!
    end
    super
  end

end
