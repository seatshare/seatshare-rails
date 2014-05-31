class TicketFile < ActiveRecord::Base
  belongs_to :tickets

  validates :user_id, :ticket_id, :path, :file_name, :presence => true

  def download_link
    "#{ENV['SEATSHARE_S3_PUBLIC']}/#{self.path}"
  end

end
