require 'twilio-ruby'

class TwilioSMS
  attr_accessor :twilio_client

  def initialize
    self.twilio_client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
    )
  end

  def assign_ticket(ticket, acting_user)
    profile = ticket.assigned.profile
    return false unless !profile.mobile.blank? && profile.sms_notify
    twilio_client.messages.create(
      from: ENV['TWILIO_OUTBOUND_NUMBER'], to: profile.mobile_e164,
      body: "#{acting_user.first_name} has assigned you "\
        "#{ticket.display_name} for #{ticket.event.display_name}. Log in to "\
        'https://myseatshare.com to view.'
    )
  rescue StandardError => e
    e.message
  end

  def request_ticket(ticket, acting_user)
    profile = ticket.owner.profile
    return false unless !profile.mobile.blank? && profile.sms_notify
    twilio_client.messages.create(
      from: ENV['TWILIO_OUTBOUND_NUMBER'], to: profile.mobile_e164,
      body: "#{acting_user.first_name} has requested #{ticket.display_name} "\
        "for #{ticket.event.display_name}. Log in to "\
        'https://myseatshare.com to assign.'
    )
  rescue StandardError => e
    e.message
  end

  def recent_messages
    twilio_client.account.messages.list || []
  rescue StandardError => e
    e.message
  end

  def sms_usage
    twilio_client.account.usage.records.last_month.list || []
  rescue StandardError => e
    e.message
  end
end
