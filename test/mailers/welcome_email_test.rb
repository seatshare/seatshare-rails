require 'test_helper'

class WelcomeEmailTest < ActionMailer::TestCase

  test "send welcome email" do
    user = User.find(1)

    email = WelcomeEmail.welcome(user).deliver

    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['no-reply@seatsha.re'], email.from
    assert_equal ['stonej@example.net'], email.to
    assert_equal 'Welcome to SeatShare, Jim!', email.subject
  end

end
