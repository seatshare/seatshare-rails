class WelcomeEmail < ActionMailer::Base
  default from: "no-reply@myseatshare.com"
  layout 'email'

  def welcome(user=nil)
    @recipient = user

    mail(
      to: "#{@recipient.display_name} <#{@recipient.email}>",
      subject: "Welcome to SeatShare, #{@recipient.first_name}!"
    )
  end

end
