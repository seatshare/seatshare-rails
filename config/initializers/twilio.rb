require 'global_phone'

# Configure the Twilio gem
# These are required to send/receive SMS data
if ENV['TWILIO_ACCOUNT_SID'].nil? || ENV['TWILIO_AUTH_TOKEN'].nil?
  Rails.logger.warn "Twilio configuration is not present!"
end

GlobalPhone.db_path = Rails.root.join('db/global_phone.json')