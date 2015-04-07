require 'twilio-ruby'

##
# Twilio SMS class
class TwilioSMS
  attr_accessor :twilio_client

  ##
  # Initialize new object
  def initialize
    self.twilio_client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    )
  end

  ##
  # Send notification of an assigned ticket
  def assign_ticket(ticket, acting_user)
    assignee = ticket.assigned
    return false unless !assignee.mobile.blank? && user.sms_notify
    twilio_client.messages.create(
      from: ENV['TWILIO_OUTBOUND_NUMBER'], to: assignee.mobile_e164,
      body: "#{acting_user.display_name} has assigned you "\
        "#{ticket.display_name} for #{ticket.event.event_name}. Log in to "\
        'https://myseatshare.com to view.'
    )
  rescue StandardError => e
    e.message
  end

  ##
  # Send notification of a requested ticket
  def request_ticket(ticket, acting_user)
    owner = ticket.owner
    return false unless !owner.mobile.blank? && owner.sms_notify
    twilio_client.messages.create(
      from: ENV['TWILIO_OUTBOUND_NUMBER'], to: owner.mobile_e164,
      body: "#{acting_user.display_name} has requested #{ticket.display_name} "\
        "for #{ticket.event.event_name}. Log in to "\
        'https://myseatshare.com to assign.'
    )
  rescue StandardError => e
    e.message
  end

  ##
  # Get the recent SMS messages from the API
  def recent_messages
    twilio_client.account.messages.list || []
  rescue StandardError => e
    e.message
  end

  ##
  # Get the usage statistics for Twilio account
  def sms_usage
    twilio_client.account.usage.records.last_month.list || []
  rescue StandardError => e
    e.message
  end
end
