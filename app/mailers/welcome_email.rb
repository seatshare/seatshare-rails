class WelcomeEmail < ActionMailer::Base
  default from: "no-reply@seatsha.re"
  layout 'email'

  def welcome(user=nil)
    @recipient = user

    mail(
      to: "#{@recipient.full_name} <#{@recipient.email}>",
      subject: "Welcome to SeatShare, #{@recipient.first_name}!"
    )
  end

end
