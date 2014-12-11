##
# Ticket file model
class TicketFile < ActiveRecord::Base
  belongs_to :ticket

  validates :user_id, :ticket_id, :path, :file_name, presence: true

  ##
  # Format path as a download link
  def download_link
    "#{ENV['SEATSHARE_S3_PUBLIC']}/#{path}"
  end
end
