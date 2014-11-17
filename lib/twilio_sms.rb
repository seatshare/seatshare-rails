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
    begin
      send = self.twilio_client.messages.create(
        from: ENV['TWILIO_OUTBOUND_NUMBER'],
        to: ticket.assigned.profile.mobile_e164,
        body: "#{acting_user.first_name} has assigned you #{ticket.display_name} for #{ticket.event.display_name}. Log in to https://myseatshare.com to view."
      )
    rescue Exception => e
      send = e.message
    end
    return send
  end

  def request_ticket(ticket, acting_user)
    if ticket.owner.profile.mobile.blank? || ticket.owner.profile.sms_notify != true
      return false
    end
    begin
      send = self.twilio_client.messages.create(
        from: ENV['TWILIO_OUTBOUND_NUMBER'],
        to: ticket.owner.profile.mobile_e164,
        body: "#{acting_user.first_name} has requested #{ticket.display_name} for #{ticket.event.display_name}. Log in to https://myseatshare.com to assign."
      )
    rescue
      send = e.message
    end
    return send
  end

  def recent_messages
    begin
      self.twilio_client.account.messages.list || []
    rescue Exception => e  
      e.message
    end
  end

  def get_sms_usage
    begin
      self.twilio_client.account.usage.records.last_month.list({:category => 'sms'}) || []
    rescue Exception => e  
      e.message
    end
  end

end