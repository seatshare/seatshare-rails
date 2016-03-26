if ENV['SEATGEEK_CLIENT_ID'].nil?
  Rails.logger.warn "SeatGeek configuration is not present!"
end

SeatGeek::Connection.protocol = :https
SeatGeek::Connection.client_id = ENV['SEATGEEK_CLIENT_ID']
