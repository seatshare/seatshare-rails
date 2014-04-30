class TicketFile < ActiveRecord::Base
  belongs_to :tickets

  validates :user_id, :ticket_id, :path, :file_name, :presence => true

  def download_link
    "https://lockbox.seatsha.re/#{self.path}"
  end

end
