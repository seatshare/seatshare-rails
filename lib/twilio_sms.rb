require "twilio-ruby"

class TwilioSMS

  attr_accessor :twilio_client

  def initialize
    self.twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def assign_ticket(ticket, acting_user)
    if ticket.assigned.profile.mobile.blank? || ticket.assigned.profile.sms_notify != true
      return false
    end

    send = self.twilio_client.messages.create(
      from: ENV['TWILIO_OUTBOUND_NUMBER'],
      to: ticket.assigned.profile.mobile_e164,
      body: "#{acting_user.first_name} has assigned you #{ticket.display_name} for #{ticket.event.display_name}. Log in to https://myseatshare.com to view."
    )
  end

  def request_ticket(ticket, acting_user)

    if ticket.owner.profile.mobile.blank? || ticket.owner.profile.sms_notify != true
      return false
    end

    send = self.twilio_client.messages.create(
      from: ENV['TWILIO_OUTBOUND_NUMBER'],
      to: ticket.owner.profile.mobile_e164,
      body: "#{acting_user.first_name} has requested #{ticket.display_name} for #{ticket.event.display_name}. Log in to https://myseatshare.com to assign."
    )
  end

end