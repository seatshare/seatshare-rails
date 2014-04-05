class TicketFile < ActiveRecord::Base
  belongs_to :tickets

  validates :user_id, :ticket_id, :path, :file_name, :presence => true
end
